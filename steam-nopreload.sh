#!/bin/bash
# Desativa o LD_PRELOAD para o Steam
export LD_PRELOAD=
# Inicia o Steam
flatpak run com.valvesoftware.Steam "$@"
