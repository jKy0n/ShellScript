#!/usr/bin/env bash

start_app() {
    if ! command -v "$1" &> /dev/null; then
        echo "Erro: $1 não encontrado" >&2
        return 1
    fi
    pgrep -x "$1" > /dev/null || "$@" &
}

# Sistema
# start_app kdeconnectd
start_app pavucontrol

# Desenvolvimento
start_app code

# Produtividade
start_app obsidian
start_app rambox

# Entretenimento
start_app spotify

# Navegador
start_app firefox