#!/bin/bash

# Verificar btrfs-progs
if BTRFS=$(qlist -Iv sys-fs/btrfs-progs 2>/dev/null); then
    BTRFS_VERSION=${BTRFS##*-}
else
    echo "BtrFS or bees not installed"
    exit 0
fi

# Verificar bees
if BEES=$(qlist -Iv sys-fs/bees 2>/dev/null); then
    BEES_VERSION=${BEES##*-}
else
    echo "BtrFS or bees not installed"
    exit 0
fi

# Saída final
echo "BtrFS $BTRFS_VERSION + Bees $BEES_VERSION"
