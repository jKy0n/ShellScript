#!/bin/sh
TEMP=$(cat /sys/class/drm/card0/device/hwmon/hwmon*/temp1_input 2>/dev/null | head -1)
TEMP_C=$((TEMP / 1000))
echo "${TEMP_C}°C"