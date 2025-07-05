#!/bin/sh
# Para RX 7800XT. Use o índice correto de cardX (normalmente card0)
BUSY=$(cat /sys/class/drm/card0/device/gpu_busy_percent 2>/dev/null)
if [ -z "$BUSY" ]; then
    # Fallback para rocm-smi
    BUSY=$(rocm-smi --showuse | awk '/GPU use/ {print $NF}' | tr -d '%')
fi
printf "%3d%%\n" "${BUSY:-0}"