#!/bin/bash

export DISPLAY=:0

# Notificar o systemd que o serviço terminou
notify-send -u normal -i /usr/share/icons/Papirus/48x48/apps/distributor-logo-gentoo.svg "Portage" "Sincronização finalizada"
