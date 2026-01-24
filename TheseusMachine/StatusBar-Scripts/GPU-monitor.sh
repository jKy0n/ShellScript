#!/bin/sh
# GPU Info: Uso, Frequência e Temperatura (padronizado)

# Uso da GPU (%)
USAGE=$(cat /sys/class/drm/card*/device/gpu_busy_percent 2>/dev/null)
if [ -z "$USAGE" ]; then
  USAGE=$(rocm-smi --showuse | awk '/GPU use/ {print $NF}' | tr -d '%')
fi

# Frequência da GPU (MHz)
FREQ=$(cat /sys/class/drm/card*/device/pp_dpm_sclk 2>/dev/null | awk '/\*/ {print $2}')
if [ -z "$FREQ" ]; then
  FREQ=$(rocm-smi --showclocks | awk '/DCEFCLK/ {print $2}')
fi

# Temperatura da GPU (°C)
TEMP=$(cat /sys/class/drm/card*/device/hwmon/hwmon*/temp1_input 2>/dev/null | head -1)
TEMP_C=0
[ -n "$TEMP" ] && TEMP_C=$((TEMP / 1000))

# Saída padronizada
echo "
usage_percent: ${USAGE:-0}
frequency_MHz: ${FREQ:-0}
temperature_Celsius: ${TEMP_C:-0}
"
