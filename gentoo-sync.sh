#!/usr/bin/env bash
#
#
# Comandos do seu script
(emerge-webrsync && emerge --sync) | ts '[%d-%m-%Y %H:%Mh]' >> /home/jkyon/.logs/GentooUpdateRoutine.log
#emerge-webrsync && emerge --sync
#
#
#
# Enviar notificação
notify-send "Gentoo Updated! =)"