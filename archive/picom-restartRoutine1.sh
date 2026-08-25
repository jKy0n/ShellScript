#!/bin/bash

export DISPLAY=:0
export DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus

LOG="/home/jkyon/.local/logs/picom-monitor.log"
mkdir -p "$(dirname "$LOG")"
echo "[ $(date '+%Y-%m-%d %H:%M:%S') ] Monitorando picom..." >> "$LOG"

pid=$(pgrep -x picom)
if [ -z "$pid" ]; then
  echo "[ $(date '+%Y-%m-%d %H:%M:%S') ] Picom não está rodando!" >> "$LOG"
  exit 0
fi

# Obtém uso RSS em kB → converte para MB
rss_kb=$(ps -p "$pid" -o rss=)
rss_mb=$((rss_kb / 1024))
echo "[ $(date '+%Y-%m-%d %H:%M:%S') ] Picom PID $pid usa ${rss_mb} MB de RAM" >> "$LOG"

LIMIT_MB=800
if [ "$rss_mb" -ge "$LIMIT_MB" ]; then
  echo "[ $(date '+%Y-%m-%d %H:%M:%S') ] Excedeu ${LIMIT_MB}MB: reiniciando picom" >> "$LOG"
  systemctl --user restart picom.service
  # notify-send -u normal -i /usr/share/icons/Papirus/48x48/devices/display.svg \
  #   Picom "Reiniciado (uso: ${rss_mb} MB ≥ ${LIMIT_MB} MB)"
  /usr/bin/awesome-client 'naughty = require("naughty")
                            naughty.notify({
                            title = "Teste",
                            text = "Notificação por awesome-client e naughty",
                            timeout = 5
                            })'
  echo "[ $(date '+%Y-%m-%d %H:%M:%S') ] Picom reiniciado, novo PID: $(pgrep -x picom)" >> "$LOG"
else
  echo "[ $(date '+%Y-%m-%d %H:%M:%S') ] Picom dentro do limite." >> "$LOG"
fi
