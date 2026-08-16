#!/usr/bin/env bash
#
#
#        Title:      startUpApps-TheseusMachine.sh
#        Brief:      Script para iniciar aplicativos essenciais na inicialização do sistema
#        Path:       /home/jkyon/ShellScript/TheseusMachine/startUpApps-TheseusMachine.sh
#        Author:     John Kennedy a.k.a. jKyon
#        Created:    2025-07-29
#        Updated:    2026-03-14
#        Notes:
#


# Função para iniciar com tratamento de erro
start_app() {
    if ! command -v "$1" &> /dev/null; then
        echo "Erro: $1 não encontrado" >&2
        return 1
    fi
    "$1" &
}

# --- Audio ---
start_app "pavucontrol"              # Mixer de áudio
start_app "spotify"                  # Player de música

# --- Produtividade ---
start_app "code"                     # VS Code editor de texto e IDE
start_app "obsidian"                 # Obsidian para notas

# --- Comunicação ---
start_app "/home/jkyon/gitApps/appImages/Rambox/Rambox.AppImage"  # Redes sociais e comunicação unificada
start_app "discord"                  # Discord para comunicação
start_app "thunderbird"              # Cliente de email

# --- Entretenimento ---
start_app "google-chrome-stable"     # Navegador web Chrome (Para streaming)
start_app "firefox"                  # Navegador web Firefox (Para uso geral)