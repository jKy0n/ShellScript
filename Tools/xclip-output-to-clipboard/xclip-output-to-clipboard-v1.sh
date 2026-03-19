#!/bin/bash

# Verifica se foi passado um comando como argumento
if [ -z "$1" ]; then
    echo "Uso: $0 'comando'"
    exit 1
fi

# Executa o comando e captura a saída junto com o próprio comando
OUTPUT="Comando executado: $@\n\n"
OUTPUT+="$(eval "$@" 2>&1)"

# Envia a saída para o clipboard
echo -e "$OUTPUT" | xclip -selection clipboard

# Mensagem de confirmação
echo "Comando e saída capturados no clipboard!"

