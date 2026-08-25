#!/usr/bin/env bash
#
#       Title:      startUpApps-Viamar-PC.sh
#       Brief:      Script para iniciar os aplicativos de inicialização do Viamar PC
#       Path:       /home/jkyon/ShellScript/Viamar-PC/startUpApps-Viamar-PC.sh
#       Author:     John Kennedy a.k.a. jKyon
#       Created:    2025-07-30
#       Updated:    2026-03-16
#       Notes:      My apps selection for work, study and usage on Viamar PC
#


start_app() {
    if ! command -v "$1" &> /dev/null; then
        echo "Erro: $1 não encontrado" >&2
        return 1
    fi
    pgrep -x "$1" > /dev/null || "$@" &
}

# Start applications
# Volume control
start_app pavucontrol

# Development
start_app code

# Productivity
start_app obsidian

# Communication
start_app rambox

# Music player
start_app spotify

# Web browser
start_app firefox