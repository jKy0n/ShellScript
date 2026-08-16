#!/bin/sh

for hw in /sys/class/hwmon/hwmon*; do
  name="$(cat "$hw/name" 2>/dev/null)"
  if [ "$name" = "k10temp" ]; then
    temp=$(awk '{printf "%.0f\n", $1/1000}' "$hw/temp1_input")
    echo "${temp}°C"
    exit
  fi
done

# fallback genérico
for inp in /sys/class/hwmon/hwmon*/temp*_input; do
  temp=$(awk '{printf "%.0f\n", $1/1000}' "$inp" 2>/dev/null)
  [ -n "$temp" ] && { echo "${temp}°C"; exit; }
done