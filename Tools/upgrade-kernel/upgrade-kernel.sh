#!/usr/bin/env bash
#
#
#        Title:      upgrade-kernel.sh
#        Brief:      Automação para preparar o kernel para upgrade usando o modprobed-db
#        Path:       /home/jkyon/ShellScript/Tools/upgrade-kernel/upgrade-kernel.sh
#        Author:     John Kennedy a.k.a. jKyon
#        Created:    2026-03-14
#        Updated:    2026-11-19
#        Notes:      Compartilhado entre as máquinas com kernel CachyOS
#                    (TheseusMachine, Viamar-PC) desde 2026-11-19; antes morava
#                    em TheseusMachine/tools/. Padrão: build local + ccache.
#                    --distcc (2026-11-23): ccache → distcc nos misses, com os
#                    hosts do DISTCC_HOSTS que têm o mesmo GCC desta máquina.
#


set -eo pipefail

THREADS=""
DISTCC=0
MODPROBED_DB="${HOME}/.config/modprobed-db/modprobed.db"

usage() {
    echo
    echo "Usage:"
    echo "  upgrade-kernel -j N              (local + ccache)"
    echo "  upgrade-kernel --distcc [-j N]   (ccache → distcc; sem -j, soma dos slots)"
    echo "  upgrade-kernel --threads N"
    echo
    exit 1
}

die() {
    echo "Erro: $*" >&2
    exit 1
}

# -----------------------------
# Parse arguments
# -----------------------------

while [[ $# -gt 0 ]]; do
    case "$1" in
        -j|--threads)
            THREADS="${2:-}"
            shift 2 || usage
            ;;
        --distcc)
            DISTCC=1
            shift
            ;;
        *)
            usage
            ;;
    esac
done

if [[ -z "$THREADS" && $DISTCC -eq 0 ]]; then
    echo "Erro: número de threads não especificado."
    usage
fi
if [[ -n "$THREADS" && ! "$THREADS" =~ ^[1-9][0-9]*$ ]]; then
    die "threads precisa ser um número inteiro positivo (veio '$THREADS')."
fi

# -----------------------------
# Pré-checagens
# -----------------------------

[[ -d /usr/src/linux ]] || die "/usr/src/linux não existe (rodar 'eselect kernel set' antes)."
[[ -r /proc/config.gz ]] || die "/proc/config.gz não existe: o kernel em uso não tem IKCONFIG_PROC."
[[ -r "$MODPROBED_DB" ]] || die "banco do modprobed-db não encontrado em $MODPROBED_DB."
command -v modprobed-db >/dev/null || die "modprobed-db não instalado."

# Drivers que nunca existiram no /proc/config.gz e precisam ser forçados como
# módulo: o localmodconfig só desliga símbolo, nunca liga. Um por máquina.
HOST="${HOSTNAME:-$(cat /etc/hostname)}"
EXTRA_MODULES=()
case "${HOST,,}" in
    theseusmachine)
        # PL2303 = USB-serial do nobreak SMS (NUT sms_ser), ligado em 2026-10-14.
        EXTRA_MODULES=(USB_SERIAL_PL2303)
        ;;
esac

# Pacotes com módulo fora da árvore (linux-mod-r1.eclass) precisam de
# @module-rebuild depois do kernel novo (e, com Secure Boot, de assinatura).
mapfile -t OOT_PKGS < <(grep -l linux-mod /var/db/pkg/*/*/INHERITED 2>/dev/null \
    | sed -E 's|^/var/db/pkg/||; s|/INHERITED$||' || true)

# -----------------------------
# distcc (opcional)
# -----------------------------
# Hosts vêm do DISTCC_HOSTS (zsh/secrets do jkyon-terminal, o mesmo em todas as
# máquinas): sai a entrada desta máquina (IP do Tailscale) e todo host remoto
# fora do ar ou com GCC diferente do daqui (regra do parque: GCC divergente =
# fora do cluster). O kernel aqui é GENERIC_CPU (sem -march=native), então o
# objeto não depende da CPU de quem compila.
MODE="local + ccache"
if [[ $DISTCC -eq 1 ]]; then
    command -v distcc >/dev/null || die "distcc não instalado."
    [[ -n "${DISTCC_HOSTS//[[:space:]]/}" ]] || die "DISTCC_HOSTS vazio (vem do zsh/secrets do jkyon-terminal)."

    SELF_IP="$(tailscale ip -4 2>/dev/null | head -1 || true)"
    LOCAL_GCC="$(gcc --version | head -1)"
    KEEP=()
    SLOTS=0
    REMOTES=0

    echo "distcc: conferindo os hosts (GCC local: $LOCAL_GCC)"
    for h in $DISTCC_HOSTS; do
        name="${h%%[/,:]*}"
        n=""
        if [[ "$h" == */* ]]; then
            n="${h#*/}"
            n="${n%%[,:]*}"
        fi

        if [[ -n "$SELF_IP" && "$name" == "$SELF_IP" ]]; then
            echo "  - $name: esta máquina, fora"
            continue
        fi

        if [[ "$name" == localhost ]]; then
            n="${n:-2}"
        else
            remote_gcc="$(ssh -n -o BatchMode=yes -o ConnectTimeout=5 "$name" \
                'gcc --version | head -1' 2>/dev/null || true)"
            if [[ "$remote_gcc" != "$LOCAL_GCC" ]]; then
                echo "  - $name: fora (GCC: '${remote_gcc:-sem resposta}')" >&2
                continue
            fi
            n="${n:-4}"
            REMOTES=$((REMOTES + 1))
        fi

        echo "  + $h"
        KEEP+=("$h")
        SLOTS=$((SLOTS + n))
    done

    [[ $REMOTES -gt 0 ]] || die "nenhum host remoto do distcc no ar com o mesmo GCC."

    export DISTCC_HOSTS="${KEEP[*]}"
    export CCACHE_PREFIX=distcc
    THREADS="${THREADS:-$SLOTS}"
    MODE="ccache → distcc ($REMOTES hosts remotos, $SLOTS slots)"
fi

# Pede a senha uma vez só, no começo, e não no meio do build.
sudo -v

echo
echo "======================================"
echo "  Kernel upgrade (threads = $THREADS)"
echo "  Modo:    $MODE"
echo "  Máquina: $HOST"
echo "  Fonte:   $(readlink -f /usr/src/linux)"
echo "======================================"
echo

# -----------------------------
# Preparação
# -----------------------------

echo "[1/9] Entrando no ambiente do kernel"
cd /usr/src/linux

# Roda como usuário: o banco é o de ~/.config (o mesmo que o localmodconfig lê).
# Com sudo, gravava no banco do root, que ninguém usa.
echo "[2/9] Atualizando módulos carregados"
modprobed-db store

echo "[3/9] Copiando configuração atual"
zcat /proc/config.gz | sudo tee .config > /dev/null

# Vindo de um gentoo-kernel-bin (1º build numa máquina), o /proc/config.gz traz
# LOCALVERSION="-gentoo-dist-bin" e MODULE_SIG_KEY apontando pra chave temporária
# do build do Gentoo (/var/tmp/portage/...), que não existe: o make pararia ao
# assinar os módulos. Com o caminho padrão, o kbuild gera a chave sozinho.
# Idempotente: num kernel já compilado aqui os dois valores já são esses.
sudo scripts/config --file .config \
    --set-str LOCALVERSION "-gentoo" \
    --set-str MODULE_SIG_KEY "certs/signing_key.pem"

# ccache na frente: o "gcc" do PATH é o /usr/bin/gcc. Sem --distcc, os misses
# compilam aqui; com --distcc, o CCACHE_PREFIX=distcc manda os misses pro
# cluster. O sudo descarta variável que não esteja no --preserve-env (foi assim
# que o CCACHE_PREFIX antigo, de antes de 2026-09-26, virou no-op).
# CCACHE_COMPILERCHECK='%compiler% -v' identifica o compilador pela versão
# real do gcc, e o cache é invalidado num upgrade de GCC.
# O mesmo CC em config e build evita que o kbuild detecte troca de compilador.
KCC="ccache gcc"
kmake() {
    sudo --preserve-env=PATH,CCACHE_DIR,CCACHE_PREFIX,DISTCC_HOSTS \
        env CCACHE_COMPILERCHECK='%compiler% -v' \
        make CC="$KCC" "$@"
}

echo "[4/9] Aplicando módulos necessários"
# Redireção em vez de pipe: com pipefail, o SIGPIPE do "yes" derrubaria o script.
kmake LSMOD="$MODPROBED_DB" localmodconfig < <(yes "")

for sym in "${EXTRA_MODULES[@]}"; do
    echo "      forçando $sym=m ($HOST)"
    sudo scripts/config --file .config --module "$sym"
done

echo "[5/9] Atualizando configuração"
kmake olddefconfig

# -----------------------------
# Compilação
# -----------------------------

echo "[6/9] Compilando kernel ($MODE, -j$THREADS), por favor aguarde..."
[[ $DISTCC -eq 1 ]] && echo "      monitor em outro terminal: sudo distccmon-text 1"
SECONDS=0
kmake -j"$THREADS"
echo "      compilação: $((SECONDS / 60))min $((SECONDS % 60))s"
ccache -s | sed -n '1,6p'

# -----------------------------
# Instalação
# -----------------------------

echo "[7/9] Instalando módulos"
kmake modules_install

# installkernel: initramfs (dracut), grub.cfg e, nas máquinas com Secure Boot
# via sbctl, assinatura do /boot/kernel-<versão> pelos hooks de
# /etc/kernel/install.d.
echo "[8/9] Instalando kernel"
kmake install

# Secure Boot (2026-11-01): com o SB ligado, a IMA_ARCH_POLICY do kernel exige
# módulo assinado. Pacote com USE=modules-sign assina no @module-rebuild com a
# chave deste kernel, e o portage compila como usuário portage: sem esta ACL
# ele não lê a chave.
if [[ ${#OOT_PKGS[@]} -gt 0 ]]; then
    sudo setfacl -m u:portage:r certs/signing_key.pem
fi

echo "[9/9] Retornando para /home"
cd ~/

echo
echo "✔ Kernel compilado e instalado."
if [[ ${#OOT_PKGS[@]} -gt 0 ]]; then
    echo " ANTES de reiniciar: sudo emerge @module-rebuild"
    echo " (módulos fora da árvore: ${OOT_PKGS[*]})."
fi
echo " Conferir antes do reboot: sudo sbctl verify (se tiver Secure Boot) e o grub.cfg."
echo "   =) "
