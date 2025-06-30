#!/bin/bash

# Define o usuário com permissão restrita
READER_USER="ollama-reader"

# Pasta permitida para leitura
ALLOWED_PATHS=("/var/log" "/home/$USER")

# Verifica se o caminho é permitido
is_path_allowed() {
    local file_path=$(realpath "$1" 2>/dev/null)
    for allowed_path in "${ALLOWED_PATHS[@]}"; do
        if [[ "$file_path" == "$allowed_path"* ]]; then
            return 0
        fi
    done
    return 1
}

# Coleta metadados do arquivo
get_file_metadata() {
    local file_path="$1"
    if is_path_allowed "$file_path"; then
        if [ -e "$file_path" ]; then
            size=$(sudo -u "$READER_USER" stat -c "%s" "$file_path" 2>/dev/null)
            permissions=$(sudo -u "$READER_USER" stat -c "%A" "$file_path" 2>/dev/null)
            owner=$(sudo -u "$READER_USER" stat -c "%U" "$file_path" 2>/dev/null)
            modified=$(sudo -u "$READER_USER" stat -c "%y" "$file_path" 2>/dev/null)
            echo "METADATA:"
            echo "Caminho: $file_path"
            echo "Tamanho: $size bytes"
            echo "Permissões: $permissions"
            echo "Dono: $owner"
            echo "Modificado: $modified"
            echo "CONTEÚDO:"
            sudo -u "$READER_USER" head -c 1024 "$file_path" 2>/dev/null | strings
        else
            echo "ERRO: Arquivo não encontrado"
        fi
    else
        echo "ERRO: Acesso não permitido a este caminho"
    fi
}

if [ "$#" -ne 1 ]; then
    echo "Uso: $0 <caminho-do-arquivo>"
    exit 1
fi

get_file_metadata "$1"
