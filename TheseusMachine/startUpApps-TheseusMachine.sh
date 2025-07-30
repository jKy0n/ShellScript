#!/usr/bin/env bash
# Inicia apps com prioridades adaptadas ao uso no Viamar-PC

# Função para iniciar com tratamento de erro
start_app() {
    if ! command -v "$1" &> /dev/null; then
        echo "Erro: $1 não encontrado" >&2
        return 1
    fi
    "$1" &
}

# --- Sistema e Comunicação ---
start_app "kdeconnectd"              # Prioridade muito baixa (daemon)
start_app "kdeconnect-app"           # Interface, delay 5s após o daemon
start_app "pavucontrol"              # Mixer de áudio

# --- Produtividade ---
start_app "code"                     # VS Code com prioridade média
start_app "obsidian"                 # Obsidian para notas
start_app "/home/jkyon/gitApps/appImages/Rambox-2.5.0-linux-x64.AppImage"  # Use caminho absoluto!

# --- Comunicação ---
start_app "discord"                  # Discord após 7s
start_app "thunderbird"              # Email com baixa prioridade

# --- Entretenimento ---
start_app "spotify"                  # Máxima prioridade para áudio
start_app "firefox"                  # Navegador com prioridade média
start_app "google-chrome-stable"     # Chrome com prioridade média

# Espera apps críticos antes de continuar
wait -n  # Espera pelo menos um processo terminar (ajuste conforme necessidade)