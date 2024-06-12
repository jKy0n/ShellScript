#!/usr/bin/env bash
#
#
# Comandos do seu script
(emerge-webrsync && emerge --sync) | \
ts +'[%d-%m-%Y %H:%Mh]' >> /home/jkyon/.logs/GentooUpdateRoutine.log
#
#
# Enviar notificação
notify-send -u critical -i /usr/share/icons/Papirus/48x48/apps/distributor-logo-gentoo.svg "Gentoo Updated! =)"