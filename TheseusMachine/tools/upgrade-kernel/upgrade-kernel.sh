#!/usr/bin/env bash
#
#
#        Title:      upgrade-kernel.sh
#        Brief:      Automação para preparar o kernel para upgrade usando o modprobed-db
#        Path:       /home/jkyon/ShellScript/TheseusMachine/tools/upgrade-kernel/upgrade-kernel.sh
#        Author:     John Kennedy a.k.a. jKyon
#        Created:    2026-03-14
#        Updated:    2026-09-26
#        Notes:      Acho que dá pra melhorar!
#


set -e

THREADS=""

usage() {
    echo
    echo "Usage:"
    echo "  upgrade-kernel -j N"
    echo "  upgrade-kernel --threads N"
    echo
    exit 1
}

# -----------------------------
# Parse arguments
# -----------------------------

while [[ $# -gt 0 ]]; do
    case "$1" in
        -j|--threads)
            THREADS="$2"
            shift 2
            ;;
        *)
            usage
            ;;
    esac
done

if [[ -z "$THREADS" ]]; then
    echo "Erro: número de threads não especificado."
    usage
fi

echo
echo "======================================"
echo "  Kernel upgrade (threads = $THREADS)"
echo "======================================"
echo

# -----------------------------
# Preparação
# -----------------------------

echo "[1/9] Entrando no ambiente do kernel"
cd /usr/src/linux

echo "[2/9] Atualizando módulos carregados"
sudo modprobed-db store

echo "[3/9] Copiando configuração atual"
zcat /proc/config.gz | sudo tee .config > /dev/null

# ccache na frente do distcc: o "gcc" do PATH é o wrapper do distcc
# (/usr/lib/distcc/bin), então o ccache só chama o distcc nos misses.
# CCACHE_COMPILERCHECK='%compiler% -v' identifica o compilador pela versão
# real do gcc — sem isso o ccache usaria o binário do distcc como "compilador"
# e não invalidaria o cache num upgrade de GCC.
# O mesmo CC em config e build evita que o kbuild detecte troca de compilador.
KCC="ccache gcc"
kmake() {
    sudo --preserve-env=DISTCC_HOSTS,PATH,CCACHE_DIR \
        env CCACHE_COMPILERCHECK='%compiler% -v' \
        make CC="$KCC" "$@"
}

echo "[4/9] Aplicando módulos necessários"
yes "" | kmake LSMOD="${HOME}/.config/modprobed-db/modprobed.db" localmodconfig

echo "[5/9] Atualizando configuração"
kmake olddefconfig

# -----------------------------
# Compilação
# -----------------------------

echo "[6/9] Compilando kernel (ccache → distcc), por favor aguarde..."
kmake -j"$THREADS"
ccache -s | sed -n '1,6p'

# -----------------------------
# Instalação
# -----------------------------

echo "[7/9] Instalando módulos"
kmake modules_install

echo "[8/9] Instalando kernel"
kmake install

echo "[9/9] Retornando para /home"
cd ~/

echo
echo "✔ Kernel compilado e instalado."
echo " Para usá-lo, reinicie o sistema quando for conveniente."
echo "   =) "
echo