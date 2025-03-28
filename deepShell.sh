#!/usr/bin/env bash
# deepChat: Script para interagir com o Ollama e formatar a saída

# Verifica se o prompt foi fornecido
if [ $# -eq 0 ]; then
    echo "Erro: Forneça um prompt ou use --bat/--dry."
    echo "Exemplo: deepChat 'Explique Markdown'"
    exit 1
fi

# Opções de formatação
FORMAT="glow"  # Padrão: glow
PROMPT="$*"    # Captura todos os argumentos como prompt

# Verifica se há flags de formatação
case "$1" in
    --bat)
        FORMAT="bat"
        PROMPT="${*:2}"  # Remove a flag --bat
        ;;
    --dry)
        FORMAT="none"
        PROMPT="${*:2}"  # Remove a flag --dry
        ;;
esac

# Executa o Ollama com a formatação escolhida
case $FORMAT in
    "glow")
        ollama run deepseek-r1 "$PROMPT" | glow
        ;;
    "bat")
        ollama run deepseek-r1 "$PROMPT" | bat --language md
        ;;
    "none")
        ollama run deepseek-r1 "$PROMPT"
        ;;
    *)
        echo "Opção inválida!"
        exit 1
        ;;
esac
