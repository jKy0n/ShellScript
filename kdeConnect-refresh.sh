#!/usr/bin/env bash
#
#
#
kdeconnect-cli --refresh | \
ts +'[%Y-%m-%d - %H:%Mh]' >> /home/jkyon/.logs/crontab-jkyon.log
#
#
# Enviar notificação
notify-send -u normal -i /usr/share/icons/Papirus/64x64/apps/kdeconnect.svg "KDEconnect" "Connection refreshed\!"