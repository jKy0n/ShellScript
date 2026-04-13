#!/bin/bash

# 1. Garante que o banco de dados atual está populado com os módulos em uso
# modprobed-db store
cp -av ~/.config/modprobed-db/modprobed.db ~/.config/modprobed-db/modprobed.db.bak
awk '{print $1}' /proc/modules | sort -u > ~/.config/modprobed-db/modprobed.db

# 2. Setup de Diretórios
ORIGEM=$PWD
BASE_DIR="/home/jkyon/.config/kernel/Viamar-PC"

mkdir -p "$BASE_DIR"

rm -rf "$BASE_DIR/linux-cachyos"
cd "$BASE_DIR" || exit

# 3. Download
paru -G aur/linux-cachyos
cd linux-cachyos || exit

# 4. TRÍADE DE SED (A mágica acontece aqui)
# Altera para usar modprobed
sed -i 's/^: "${_localmodcfg:=.*}"/: "${_localmodcfg:=yes}"/' PKGBUILD
# Altera para Zen3
sed -i 's/^: "${_processor_opt:=.*}"/: "${_processor_opt:=zen3}"/' PKGBUILD
# CORRIGE O PATH (De .config/modprobed.db para .config/modprobed-db/modprobed.db)
sed -i 's|: "${_localmodcfg_path:=".*"}"|: "${_localmodcfg_path:="'"$HOME"'/.config/modprobed-db/modprobed.db"}"|' PKGBUILD

echo "PKGBUILD tunado com sucesso!"

# 5. Build e Instalação
makepkg -si

# 6. Retorno
cd "$ORIGEM"
