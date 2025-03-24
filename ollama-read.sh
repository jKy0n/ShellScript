#!/bin/bash

# Define o usuário com permissão restrita
READER_USER="ollama-reader"

# Pasta permitida para leitura (ajuste conforme necessário)
ALLOWED_PATHS=("/var/log" "/home/jkyon")

# Verifica se o arquivo solicitado está na lista de permissões
is_path_allowed() {
    local file_path=$(realpath "$1" 2>/dev/null)
    for allowed_path in "${ALLOWED_PATHS[@]}"; do
        if [[ "$file_path" == "$allowed_path"* ]]; then
            return 0  # Permite acesso
        fi
    done
    return 1  # Bloqueia acesso
}

# Lê o arquivo de forma segura
if [ "$#" -ne 1 ]; then
    echo "Uso: $0 <caminho-do-arquivo>"
    exit 1
fi

if is_path_allowed "$1"; then
    sudo -u "$READER_USER" cat "$1" 2>/dev/null || echo "[ERRO] Acesso negado ou arquivo inexistente."
else
    echo "[ERRO] Você não tem permissão para acessar este arquivo."
fi
