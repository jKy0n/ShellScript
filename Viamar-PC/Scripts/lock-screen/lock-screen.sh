#!/bin/sh
set -eu

# Apaga os monitores imediatamente
xset dpms force off

# Janela de tolerância
sleep 60

# Se ainda estiver idle após a tolerância, trava

exec i3lock --nofork --ignore-empty-password -i /home/jkyon/Pictures/Wallpapers/ArchLinux-Nebula.png
