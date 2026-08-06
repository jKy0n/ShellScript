#!/usr/bin/env bash
#
# niri-status-services.sh
# Status consolidado dos serviços systemd --user membros de graphical-session.target
# (niri-* customizados + units de pacote que compartilham o mesmo target, ex: waybar, kde-baloo)
#
# Uso: niri-status-services [--no-color]

set -uo pipefail

if [[ -t 1 && "${1:-}" != "--no-color" ]]; then
  C_RESET=$'\e[0m'; C_GREEN=$'\e[32m'; C_RED=$'\e[31m'; C_YELLOW=$'\e[33m'; C_BOLD=$'\e[1m'; C_DIM=$'\e[2m'
else
  C_RESET=""; C_GREEN=""; C_RED=""; C_YELLOW=""; C_BOLD=""; C_DIM=""
fi

section() { printf "\n${C_BOLD}═══ %s ═══${C_RESET}\n" "$1"; }

section "Membros de graphical-session.target"
mapfile -t MEMBERS < <(systemctl --user show -p Wants --value graphical-session.target | tr ' ' '\n' | grep '\.service$' | sort)
printf '%s\n' "${MEMBERS[@]}"

section "Status (load / active / enabled)"
systemctl --user list-units --all --no-legend "${MEMBERS[@]}"
echo
systemctl --user list-unit-files --no-legend "${MEMBERS[@]}"

section "Checagem de processo (1 PID esperado por unit)"
for unit in "${MEMBERS[@]}"; do
  st=$(systemctl --user is-active "$unit")
  mainpid=$(systemctl --user show -p MainPID --value "$unit")

  case "$st" in
    active) st_color="${C_GREEN}${st}${C_RESET}" ;;
    failed) st_color="${C_RED}${st}${C_RESET}" ;;
    *)      st_color="${C_YELLOW}${st}${C_RESET}" ;;
  esac

  if [[ -z "$mainpid" || "$mainpid" == "0" ]]; then
    printf "%-38s %-20s %s\n" "$unit" "$st_color" "${C_DIM}(sem PID rastreado)${C_RESET}"
    continue
  fi

  cmd=$(ps -o args= -p "$mainpid" 2>/dev/null)
  count=$(pgrep -cxf -- "$cmd" 2>/dev/null || echo 0)

  printf "%-38s %-20s PID=%-7s processos=%s\n" "$unit" "$st_color" "$mainpid" "$count"

  if (( count > 1 )); then
    printf "   ${C_RED}⚠️  ÓRFÃO — mais de 1 processo com comando idêntico:${C_RESET}\n"
    pgrep -axf -- "$cmd" | sed 's/^/      /'
  fi
done

section "Failed units (qualquer namespace)"
if ! systemctl --user --failed --no-legend | grep -q .; then
  echo "   nenhuma unit falhando"
else
  systemctl --user --failed --no-legend
fi
