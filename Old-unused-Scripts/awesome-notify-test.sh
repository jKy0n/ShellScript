#!/bin/bash

XDG_RUNTIME_DIR="/run/user/$(id -u)"
export XDG_RUNTIME_DIR

# Título da notificação
titulo="Tarefa Cron Concluída"

# Mensagem da notificação
mensagem="A tarefa agendada '$1' foi concluída com sucesso!"

# Envia a notificação
notify-send -u normal "$titulo" "$mensagem"

# Opcional: definir ícone
# notify-send -i /caminho/para/icone.png "$titulo" "$mensagem"