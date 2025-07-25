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

# Apps de Sistema (prioridade normal)
start_app "kdeconnect-app"
start_app "pavucontrol"

# Produtividade (prioridade média)
start_app "obsidian"
start_app "rambox"

# Entretenimento (prioridade alta para evitar lag)
start_app "spotify"

# Navegador (prioridade personalizada)
start_app "firefox"

# Espera apps críticos antes de continuar
wait -n  # Espera pelo menos um processo terminar (ajuste conforme necessidade)
