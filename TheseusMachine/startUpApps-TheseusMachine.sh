#!/usr/bin/env bash
#
#
#        Title:      startUpApps-TheseusMachine.sh
#        Brief:      Script para iniciar aplicativos essenciais na inicialização do sistema
#        Path:       /home/jkyon/ShellScript/TheseusMachine/startUpApps-TheseusMachine.sh
#        Author:     John Kennedy a.k.a. jKyon
#        Created:    2025-07-29
#        Updated:    2026-03-14
#       Notes:
#


# Função para iniciar com tratamento de erro
start_app() {
    if ! command -v "$1" &> /dev/null; then
        echo "Erro: $1 não encontrado" >&2
        return 1
    fi
    "$1" &
}

# --- Sistemas ---
start_app "pavucontrol"              # Mixer de áudio

# --- Produtividade ---
start_app "code"                     # VS Code editor
start_app "obsidian"                 # Obsidian para notas
start_app "/home/jkyon/gitApps/appImages/Rambox/Rambox.AppImage"  # Use caminho absoluto!

# --- Comunicação ---
start_app "discord"                  # Discord para comunicação
start_app "thunderbird"              # Cliente de email

# --- Entretenimento ---
start_app "spotify"                  # Player de música
start_app "google-chrome-stable"     # Navegador web Chrome
start_app "firefox"                  # Navegador web Firefox

# Espera apps críticos antes de continuar
wait -n  # Espera pelo menos um processo terminar (ajuste conforme necessidade)