#!/bin/sh
# PSU Info: Potência (W), Uso (%) e Temperatura (°C)

SENSOR_NAME="corsairpsu-hid-[0-9]+-[0-9]+"

# Potência (W) e Uso (%)
read_psu_usage() {
  sensors | awk -v sn="$SENSOR_NAME" '
    $0 ~ sn {found=1}
    found && /power total:/ {power=$3}
    found && /pwm1:/ {percent=$2; found=0}
    END {print power, percent}
  '
}

read POWER PERCENT <<EOF
$(read_psu_usage)
EOF

# Temperatura (°C)
TEMP=$(sensors | awk -v sn="$SENSOR_NAME" '
  $0 ~ sn {found=1; next}
  found && /vrm/ {
    match($3, /([+-]?[0-9]+(\.[0-9]+)?)/, arr)
    print int(arr[1])
    exit
  }
')

# Saída padronizada
echo "
usage_percent: ${PERCENT:-N/A}
power_W: ${POWER:-N/A}
temperature_Celsius: ${TEMP:-N/A}
"