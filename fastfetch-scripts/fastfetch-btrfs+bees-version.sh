#!/usr/bin/env bash

# Detectar a distribuição usando /etc/os-release
if [ -f /etc/os-release ]; then
    . /etc/os-release
    DISTRO=$ID
else
    echo "Não foi possível detectar a distribuição."
    exit 1
fi

# Função para Arch Linux (pacman)
check_arch() {
    # Extrai versões usando pacman -Q
    btrfs_version=$(pacman -Q btrfs-progs | awk '{print $2}')
    bees_version=$(pacman -Q bees 2>/dev/null | awk '{print $2}')

    # Se bees não estiver instalado, define como "not installed"
    if [ -z "$bees_version" ]; then
        bees_version="not installed"
    fi

    # Saída formatada
    echo "BtrFS $btrfs_version + bees $bees_version"
}

# Função para Gentoo (portage)
check_gentoo() {
    # Verificar btrfs-progs
    if BTRFS=$(qlist -Iv sys-fs/btrfs-progs 2>/dev/null); then
        BTRFS_VERSION=${BTRFS##*-}
    else
        echo "BtrFS ou bees não instalados"
        exit 0
    fi

    # Verificar bees
    if BEES=$(qlist -Iv sys-fs/bees 2>/dev/null); then
        BEES_VERSION=${BEES##*-}
    else
        echo "BtrFS ou bees não instalados"
        exit 0
    fi

    # Saída final
    echo "BtrFS $BTRFS_VERSION + Bees $BEES_VERSION"
}

# Verificar a distribuição e executar o código correspondente
case $DISTRO in
    arch)
        check_arch
        ;;
    gentoo)
        check_gentoo
        ;;
    *)
        echo "Distribuição não suportada: $DISTRO"
        exit 1
        ;;
esac