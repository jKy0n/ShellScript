#!/bin/bash

LIMIT=80
usage=$(free | awk '/Mem:/ { printf("%.0f", $3/$2 * 100) }')

if [ "$usage" -ge "$LIMIT" ]; then
  pkill picom
  sleep 1

  export DISPLAY=:0
  export XAUTHORITY=/home/jkyon/.Xauthority

  systemctl --user restart picom.service

  notify-send -u normal -i /usr/share/icons/Papirus/48x48/devices/display.svg Picom 'Compositor reiniciado'
fi
