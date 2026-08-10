#!/bin/bash
# Lê sysfs do amdgpu (card0) + hwmon2 (GPU) e monta o JSON pro Waybar.
#
# USO: gpu-monitor.sh [campo1] [campo2] ...
#   Campos válidos: usage, vram, freq, temp
#   Sem argumento nenhum = mostra os 4 (comportamento "full").
#   Exemplos:
#     gpu-monitor.sh              -> pill com os 4 empilhados
#     gpu-monitor.sh usage        -> pill só com uso%
#     gpu-monitor.sh usage vram   -> pill com uso% e VRAM
#   O tooltip SEMPRE mostra tudo, não importa quais campos você
#   escolheu pro pill — isso não muda com o argumento.
#
# ATENÇÃO — "card0" e "hwmon2" são os números de HOJE, não são
# garantidos entre boots. Conferir com:
#   readlink -f /sys/class/drm/card0/device/driver    # deve dizer amdgpu
#   cat /sys/class/drm/card0/device/hwmon/hwmon*/name  # deve dizer amdgpu
DEVICE="/sys/class/drm/card0/device"
HWMON="$DEVICE/hwmon/hwmon2"
ICON="󰢮"

usage_pct=$(<"$DEVICE/gpu_busy_percent")
vram_used_b=$(<"$DEVICE/mem_info_vram_used")
vram_total_b=$(<"$DEVICE/mem_info_vram_total")
freq_hz=$(<"$HWMON/freq1_input")
temp_edge_mc=$(<"$HWMON/temp1_input")
temp_junction_mc=$(<"$HWMON/temp2_input")

read -r vram_used_gb vram_total_gb freq_ghz freq_mhz temp_edge_c temp_junction_c <<< "$(awk \
    -v vu="$vram_used_b" -v vt="$vram_total_b" -v f="$freq_hz" \
    -v te="$temp_edge_mc" -v tj="$temp_junction_mc" '
    BEGIN {
        printf "%.0f %.0f %.0f %.0f %.0f %.0f", vu/(1024^3), vt/(1024^3), f/1000000000, f/1000000, te/1000, tj/1000
    }
')"

# Mapa nome-do-campo -> valor já formatado com unidade.
declare -A VALUES=(
    [usage]="${usage_pct}%"
    [vram]="${vram_used_gb}GB"
    [freq]="${freq_ghz}GHz"
    [temp]="${temp_junction_c}°C"
)

# Campos que entram no pill: os argumentos do exec, ou os 4 (nessa
# ordem) se nenhum foi passado.
if [ "$#" -eq 0 ]; then
    fields=(usage vram freq temp)
else
    fields=("$@")
fi

lines=("<span size='large'>$ICON</span>")
for f in "${fields[@]}"; do
    lines+=("${VALUES[$f]}")
done
text=$(printf "%s\n" "${lines[@]}")
text="${text%$'\n'}"   # tira a quebra de linha extra do fim

# Tooltip sempre completo — independe do que foi escolhido pro pill.
tooltip=$(printf "Radeon RX 7800 XT\nUso: %s%%\nVRAM: %sGB / %sGB\nClock: %sMHz\nTemp. edge: %s°C\nTemp. junction: %s°C" \
    "$usage_pct" "$vram_used_gb" "$vram_total_gb" "$freq_mhz" "$temp_edge_c" "$temp_junction_c")

jq -nc --arg text "$text" --arg tooltip "$tooltip" '{text: $text, tooltip: $tooltip}'