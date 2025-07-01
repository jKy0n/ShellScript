#!/bin/sh
# Altere para o nome exato do sensor, ex: corsair-psu-0, HXi, etc.
SENSOR_NAME="corsair-psu-0"
TEMP=$(sensors | awk -v sn="$SENSOR_NAME" '
  $0 ~ sn {found=1} 
  found && /temp1_input:/ {print $2; found=0}
')
[ -n "$TEMP" ] && echo "$((TEMP/1))°C" || echo "N/A"