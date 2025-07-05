#!/bin/sh
SENSOR_NAME="corsairpsu-hid-[0-9]+-[0-9]+"

read_psu() {
  sensors | awk -v sn="$SENSOR_NAME" '
    $0 ~ sn {found=1}
    found && /power total:/ {printf "%.0f ", $3}
    found && /pwm1:/ {printf "%s\n", $2; found=0}
  '
}

OUT=$(read_psu)
read POWER PERCENT <<EOF
$OUT
EOF

[ -n "$POWER" ]  || POWER="N/A"
[ -n "$PERCENT" ]|| PERCENT="N/A"

echo "$POWER W ($PERCENT)"
