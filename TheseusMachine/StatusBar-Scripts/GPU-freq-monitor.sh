#!/bin/sh
FREQ=$(cat /sys/class/drm/card0/device/pp_dpm_sclk 2>/dev/null | grep "*" | awk '{print $2}')
if [ -z "$FREQ" ]; then
    # Alternativamente, pode usar rocm-smi
    FREQ=$(rocm-smi --showclocks | grep 'DCEFCLK' | awk '{print $2}')  # Editar depois pra aparecer MHz separado
fi
echo "${FREQ:-0}"