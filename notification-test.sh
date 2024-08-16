#!/bin/bash
#
# Defina variáveis padrão
ICON="/usr/share/icons/ePapirus-Dark/32x32/devices/media-floppy.svg"  # Caminho para o ícone desejado
TITLE="Título da Notificação"
BODY="Esta é uma mensagem de exemplo para testar o comportamento das notificações no AwesomeWM."
URGENCY="normal"  # Opções: low, normal, critical
EXPIRE_TIME=5000  # Tempo em milissegundos para a notificação expirar

# Função para mostrar a notificação
send_notification() {
  notify-send -u "$URGENCY" -t "$EXPIRE_TIME" -i "$ICON" "$TITLE" "$BODY"
}

# Parâmetros opcionais para personalização via linha de comando
while getopts ":t:b:i:u:e:" opt; do
  case $opt in
    t) TITLE="$OPTARG"
    ;;
    b) BODY="$OPTARG"
    ;;
    i) ICON="$OPTARG"
    ;;
    u) URGENCY="$OPTARG"
    ;;
    e) EXPIRE_TIME="$OPTARG"
    ;;
    \?) echo "Opção inválida -$OPTARG" >&2
    ;;
  esac
done

# Envia a notificação
send_notification

