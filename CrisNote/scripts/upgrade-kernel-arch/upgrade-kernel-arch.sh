#!/bin/bash

# 1. Popula DB (Descomentado para garantir segurança no Crisnote)
# modprobed-db store

# 2. Setup
ORIGEM=$PWD
BASE_DIR="/home/jkyon/.config/kernel/CrisNote/"
mkdir -p "$BASE_DIR"
rm -rf "$BASE_DIR/linux-cachyos"
cd "$BASE_DIR" || exit

# 3. Download
paru -G aur/linux-cachyos
cd linux-cachyos || exit

# 4. Ajustes de Compilação
sed -i 's/^: "${_localmodcfg:=.*}"/: "${_localmodcfg:=yes}"/' PKGBUILD
sed -i 's/^: "${_processor_opt:=.*}"/: "${_processor_opt:=alderlake}"/' PKGBUILD
# Desabilitar AVX10 para evitar o erro de target não reconhecido
sed -i 's/^: "${_use_avx10:=.*}"/: "${_use_avx10:=no}"/' PKGBUILD
# Ajuste de Path do DB
sed -i 's|: "${_localmodcfg_path:=".*"}"|: "${_localmodcfg_path:="/home/jkyon/.config/modprobed-db/modprobed.db"}"|' PKGBUILD

echo "PKGBUILD tunado para Alder Lake (Sem AVX10)!"

# 5. Build com Proteção de Recursos (8GB RAM Limit)
env \
  PATH=/usr/local/sbin:/usr/local/bin:/usr/bin \
  TMPDIR=/home/jkyon/.tmp \
  CC=clang \
  CXX=clang++ \
  BUILDDIR=/home/jkyon/.build/makepkg \
  makepkg -si

# 6. Retorno
cd "$ORIGEM"
