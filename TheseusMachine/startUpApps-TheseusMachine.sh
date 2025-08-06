#!/usr/bin/env bash

# Função para iniciar com tratamento de erro
start_app() {
    if ! command -v "$1" &> /dev/null; then
        echo "Erro: $1 não encontrado" >&2
        return 1
    fi
    "$1" &
}

# --- Sistemas ---
start_app "kdeconnectd"              # Daemon de comunicação KDE Connect
start_app "kdeconnect-app"           # Interface após o daemon
start_app "pavucontrol"              # Mixer de áudio

# --- Produtividade ---
start_app "code"                     # VS Code editor
start_app "obsidian"                 # Obsidian para notas
start_app "/home/jkyon/gitApps/appImages/Rambox-2.5.0-linux-x64.AppImage"  # Use caminho absoluto!

# --- Comunicação ---
start_app "discord"                  # Discord para comunicação
start_app "thunderbird"              # Cliente de email

# --- Entretenimento ---
start_app "spotify"                  # Player de música
start_app "google-chrome-stable"     # Navegador web Chrome
start_app "firefox"                  # Navegador web Firefox

# Espera apps críticos antes de continuar
wait -n  # Espera pelo menos um processo terminar (ajuste conforme necessidade)