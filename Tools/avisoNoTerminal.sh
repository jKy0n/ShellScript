#! /usr/bin/bash

# =====================================================================================================
#  Author/Coder: jKyon aka John Kennedy Loria Segundo
#  Description: just a script to sound alarm after a terminal command
# =====================================================================================================

# Script para alertar ao final de um comando no Linux

# Função para enviar notificações
send_notification() {
    local title="$1"
    local message="$2"

    if command -v notify-send &> /dev/null; then
        notify-send -u critical "$title" "$message"
    else
        # Caso notify-send não esteja disponível, imprime no terminal
        echo "[$title] $message"
    fi
}

# Executa o comando fornecido como argumento
"$@"
status=$?

# Verifica o status de saída do comando
if [ $status -eq 0 ]; then
    echo -e '\a' # Emite um beep
    send_notification "Comando concluído" "O comando '$*' foi executado com sucesso!"
else
    send_notification "Erro no comando" "O comando '$*' falhou com o código $status."
fi
