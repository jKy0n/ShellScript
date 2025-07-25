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
start_app "kdeconnect-app" 15
start_app "pavucontrol" 10

# Produtividade (prioridade média)
start_app "obsidian" 5
start_app "rambox" 5

# Entretenimento (prioridade alta para evitar lag)
start_app "spotify" 0

# Navegador (prioridade personalizada)
start_app "firefox" 5

# Espera apps críticos antes de continuar
wait -n  # Espera pelo menos um processo terminar (ajuste conforme necessidade)
