#!/usr/bin/env bash

# Extrai versões usando pacman -Q
btrfs_version=$(pacman -Q btrfs-progs | awk '{print $2}')
bees_version=$(pacman -Q bees 2>/dev/null | awk '{print $2}')

# Se bees não estiver instalado, define como "not installed"
if [ -z "$bees_version" ]; then
    bees_version="not installed"
fi

# Saída formatada
echo "BtrFS $btrfs_version + bees $bees_version"
