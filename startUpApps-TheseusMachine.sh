#!/usr/bin/env bash
# Inicia apps com prioridades adaptadas ao Ryzen 9 + AwesomeWM

# --- Controle de CPU (Opcional) ---
# Se absolutamente necessário:
# sudo cpupower frequency-set -g performance || true  # Ignora erros se não disponível

# --- Função de Inicialização Segura ---
start_app() {
    local cmd="$1"
    local nice_level="$2"
    local delay="${3:-0}"  # Delay padrão 0
    
    sleep "${delay}s"
    
    if ! command -v "$(echo "$cmd" | awk '{print $1}')" &>/dev/null; then
        echo "Erro: $cmd não encontrado" >&2
        return 1
    fi
    
    nice -n "$nice_level" /bin/bash -c "$cmd" &
}

# --- Sistema e Comunicação ---
start_app "kdeconnectd" 19           # Prioridade muito baixa (daemon)
start_app "kdeconnect-app" 18 5      # Interface, delay 5s após o daemon
start_app "pavucontrol" 15           # Mixer de áudio

# --- Produtividade ---
start_app "code" 5 2                 # VS Code com prioridade média
start_app "obsidian" 5 3             
start_app "~/gitApps/Rambox-*-linux-x64.AppImage" 5 5  # Use caminho absoluto!

# --- Comunicação ---
start_app "discord" 5 7              # Discord após 7s
start_app "thunderbird" 10 10        # Email com baixa prioridade

# --- Entretenimento ---
start_app "spotify" 0 5              # Máxima prioridade para áudio
start_app "firefox" 5 12             
start_app "google-chrome-stable" 5 15

# --- Voltar ao Governor Normal (Se habilitou performance) ---
# (Ajuste o sleep conforme necessidade real)
# (sleep 30s ; sudo cpupower frequency-set -g ondemand) &

exit 0
