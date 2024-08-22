#!/bin/bash


export DISPLAY=:0
# export DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus


# Notificar que o serviço está em execução
# /usr/bin/systemd-notify --ready --status="Sincronização do Portage Iniciada"

# Executar o comando de sincronização ou qualquer outro processo
notify-send -u normal -i /usr/share/icons/Papirus/48x48/apps/distributor-logo-gentoo.svg "Portage" "Iniciando sincronização"

# Notificar que o serviço terminou
# /usr/bin/systemd-notify --status="Sincronização do Portage Concluída"

