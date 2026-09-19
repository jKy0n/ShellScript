#!/usr/bin/env bash

# Detectar a distribuição usando /etc/os-release
if [ -f /etc/os-release ]; then
    . /etc/os-release
    DISTRO=$ID
else
    echo "Não foi possível detectar a distribuição."
    exit 1
fi

grub_version=$(grub-install --version | awk '{print $3}')

# Função para Arch Linux (pacman)
check_arch() {
    grub_btrfs_version=$(pacman -Q grub-btrfs 2>/dev/null | awk '{print $2}')

    if [ -z "$grub_btrfs_version" ]; then
        grub_btrfs_version="not installed"
    fi

    echo "grub $grub_version + grub-btrfs $grub_btrfs_version"
}

# Função para Gentoo (portage)
check_gentoo() {
    if GRUB_BTRFS=$(qlist -Iv app-backup/grub-btrfs 2>/dev/null); then
        GRUB_BTRFS_VERSION=${GRUB_BTRFS##*-}
    else
        echo "grub $grub_version + grub-btrfs not installed"
        exit 0
    fi

    echo "grub $grub_version + grub-btrfs $GRUB_BTRFS_VERSION"
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
