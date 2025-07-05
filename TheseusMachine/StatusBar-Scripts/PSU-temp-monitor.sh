#!/bin/sh

TEMP=$(sensors | awk '
  /^corsairpsu-hid-[0-9]+-[0-9]+/ {found=1; next}
  found && /vrm/ {
    match($3, /([+-]?[0-9]+(\.[0-9]+)?)/, arr)
    print int(arr[1])
    exit
  }
')
[ -n "$TEMP" ] && echo "${TEMP}°C" || echo "N/A"