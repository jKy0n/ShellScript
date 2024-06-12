#!/usr/bin/env bash
#
#
# Comandos do seu script
(rsync -avP /etc/portage ~/.dotfiles/ & rsync -avP /etc/fstab ~/.dotfiles/) | \
ts +'[%Y-%m-%d - %H:%Mh]' >> /home/jkyon/.logs/crontab-jkyon.log
#
#
# Enviar notificação
notify-send -u critical -i /usr/share/icons/Papirus/48x48/apps/distributor-logo-gentoo.svg "System Updater" "Portage backup sucessfully\! =)" 