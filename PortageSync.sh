#!/usr/bin/env bash
#
#
#
# NOTE: Agora vaai!! version 2.0:
#
#
ICON="/usr/share/icons/Papirus/48x48/apps/distributor-logo-gentoo.svg"
LOG_FILE="/home/jkyon/.logs/portageSync-dailyRoutine.log"
#
#
  emerge --sync
      if [ $? -ne 0 ]; then
          echo "$(date +'[%Y-%m-%d - %H:%Mh]' - Error ao tentar sincrozar repositorios)" >> $LOG_FILE
          sudo -u jkyon notify-send -u critical -i $ICON "Portage" "Failed to sync repository"
      else
          sudo -u jkyon notify-send -u normal -i $ICON "Portage" "Gentoo is sync"
      fi
#
#
#
# NOTE: Version 1:
#
# Commandos do seu script
#(emerge-webrsync && emerge --sync && emaint sync --auto) | ts +'[%d-%m-%Y %H:%Mh ]' >> /home/jkyon/.logs/GentooUpdateRoutine.log
#emerge --sync | ts +'[%Y-%m-%d - %H:%Mh ]' >> /home/jkyon/.logs/GentooUpdateRoutine.log
#
#
#
# Enviar notificação
#notify-send -u critical "Portage" "Gentoo Updated\! =)"
#
