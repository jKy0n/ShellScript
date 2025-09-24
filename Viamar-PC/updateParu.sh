#!/usr/bin/env bash
# filepath: /home/jkyon/ShellScript/Viamar-PC/updateParu.sh

# Verifica se o paru está instalado
if ! command -v paru &> /dev/null; then
     echo "Paru não está instalado. Instale com: sudo pacman -S paru"
     exit 1
fi

# Atualiza os repositórios e mostra atualizações disponíveis
paru -Syy && paru -Qu