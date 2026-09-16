#!/usr/bin/env bash
# Concede/revoga sudo sem senha (NOPASSWD:ALL) pro usuário que chamou o sudo,
# via /etc/sudoers.d/tmp-claude-nopasswd. Existe porque o cache de `sudo -v`
# é por tty/sessão — não vale entre terminal local e SSH, então em sessão
# separada (ex: Claude Code via SSH) não há como "herdar" um sudo já
# autenticado em outro terminal.
#
# Precisa rodar com sudo. Só quem tem a senha consegue ativar (`on`) ou
# desativar (`off`) a primeira vez a partir de um estado sem NOPASSWD — depois
# de ativado, `off` também pode ser rodado sem senha (o NOPASSWD cobre o
# próprio comando de desativar).
#
# `on` agenda um auto-off via systemd-run (rede de segurança caso esqueçam
# de rodar `off`) — unit transiente, não sobrevive a reboot (ver README).
set -euo pipefail

SUDOERS_FILE=/etc/sudoers.d/tmp-claude-nopasswd
TARGET_USER="${SUDO_USER:-$USER}"
EXPIRE_UNIT=tmp-claude-nopasswd-expire
DEFAULT_EXPIRE="${TMP_CLAUDE_NOPASSWD_EXPIRE:-4h}"
SCRIPT_PATH="$(readlink -f "$0")"

usage() {
  echo "Uso: sudo $0 on [DURAÇÃO] | off | status" >&2
  echo "DURAÇÃO no formato do systemd (ex: 2h, 90min) — default: $DEFAULT_EXPIRE" >&2
  exit 1
}

require_root() {
  if [[ $EUID -ne 0 ]]; then
    echo "Precisa rodar com sudo." >&2
    exit 1
  fi
}

cmd_on() {
  require_root
  local tmp
  tmp="$(mktemp)"
  echo "${TARGET_USER} ALL=(ALL) NOPASSWD: ALL" > "$tmp"

  if ! visudo -c -f "$tmp"; then
    echo "Sintaxe inválida, abortando (nada foi instalado)." >&2
    rm -f "$tmp"
    exit 1
  fi

  install -m 0440 -o root -g root "$tmp" "$SUDOERS_FILE"
  rm -f "$tmp"
  echo "Ativado: ${TARGET_USER} tem sudo sem senha (NOPASSWD:ALL)."
  echo "Arquivo: $SUDOERS_FILE"

  local duration="${1:-$DEFAULT_EXPIRE}"
  systemctl stop "${EXPIRE_UNIT}.timer" >/dev/null 2>&1 || true
  if systemd-run --collect --unit="$EXPIRE_UNIT" \
       --description="Auto-off do NOPASSWD temporário (rede de segurança)" \
       --on-active="$duration" -- "$SCRIPT_PATH" off >/dev/null 2>&1; then
    echo "Auto-expira em $duration, a menos que você rode '$0 off' antes."
  else
    echo "⚠️  NOPASSWD ativo mas NÃO consegui agendar o auto-off (duração '$duration' inválida?). Rode '$0 off' manualmente quando terminar!" >&2
  fi
}

cmd_off() {
  require_root
  if systemctl is-active --quiet "${EXPIRE_UNIT}.timer" 2>/dev/null; then
    systemctl stop "${EXPIRE_UNIT}.timer" >/dev/null 2>&1 || true
    echo "Timer de auto-expiração cancelado."
  fi
  if [[ -f "$SUDOERS_FILE" ]]; then
    rm -f "$SUDOERS_FILE"
    echo "Desativado. Removido: $SUDOERS_FILE"
  else
    echo "Já estava inativo (arquivo não existe: $SUDOERS_FILE)."
  fi
}

cmd_status() {
  # /etc/sudoers.d é 0750 root:root — sem sudo, o teste abaixo sempre
  # falharia (permission error), mascarando um estado "ativo" como inativo.
  require_root
  if [[ -f "$SUDOERS_FILE" ]]; then
    echo "Ativo: $SUDOERS_FILE"
    if systemctl is-active --quiet "${EXPIRE_UNIT}.timer" 2>/dev/null; then
      systemctl list-timers "${EXPIRE_UNIT}.timer" --no-legend
    else
      echo "⚠️  ATENÇÃO: ativo SEM auto-expiração agendada — não vai desligar sozinho (provável causa: reboot depois do 'on', timer transiente não sobrevive)."
    fi
  else
    echo "Inativo"
  fi
}

case "${1:-}" in
  on) shift; cmd_on "$@" ;;
  off) cmd_off ;;
  status) cmd_status ;;
  *) usage ;;
esac
