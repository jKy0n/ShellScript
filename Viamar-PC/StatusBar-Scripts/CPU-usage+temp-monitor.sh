#!/bin/sh
# CPU Info: Frequência, Uso e Temperatura

# Temperatura da CPU (ajuste o caminho conforme necessário)
TEMP=""
for hw in /sys/class/hwmon/hwmon*; do
  name="$(cat "$hw/name" 2>/dev/null)"
  if [ "$name" = "k10temp" ]; then
    TEMP=$(awk '{printf "%.0f", $1/1000}' "$hw/temp1_input")
    break
  fi
done

# fallback genérico se não encontrou k10temp
if [ -z "$TEMP" ]; then
  for inp in /sys/class/hwmon/hwmon*/temp*_input; do
    TEMP=$(awk '{printf "%.0f", $1/1000}' "$inp" 2>/dev/null)
    [ -n "$TEMP" ] && break
  done
fi

# Uso da CPU em %
PREV_IDLE=$(awk '/^cpu / {print $5}' /proc/stat)
PREV_TOTAL=$(awk '/^cpu / {sum=0; for(i=2;i<=NF;i++) sum+=$i; print sum}' /proc/stat)
sleep 0.5
IDLE=$(awk '/^cpu / {print $5}' /proc/stat)
TOTAL=$(awk '/^cpu / {sum=0; for(i=2;i<=NF;i++) sum+=$i; print sum}' /proc/stat)
DIFF_IDLE=$((IDLE - PREV_IDLE))
DIFF_TOTAL=$((TOTAL - PREV_TOTAL))
USAGE=$(( (100 * (DIFF_TOTAL - DIFF_IDLE)) / DIFF_TOTAL ))

# Exibe as informações
echo "      ${USAGE}%     ${TEMP}°C  "