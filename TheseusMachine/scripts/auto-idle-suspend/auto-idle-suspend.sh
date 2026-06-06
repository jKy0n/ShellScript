#!/usr/bin/env bash
set -eu

export DISPLAY="${DISPLAY:-:0}"

SCRIPT_DIR="/home/jkyon/ShellScript/TheseusMachine/scripts/auto-idle-suspend"

# Desliga o screensaver clássico do X e mantém DPMS disponível
xset s off
xset +dpms

exec /usr/local/bin/xidlehook \
  --not-when-fullscreen \
  --timer 600 \
    "$SCRIPT_DIR/lock-screen.sh" \
    "" \
  --timer 1740 \
    "xset dpms force off" \
    "" \
  --timer 1800 \
    "systemctl suspend" \
    ""
