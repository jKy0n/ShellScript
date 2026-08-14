#!/bin/bash
# Lê o hwmon do driver corsair-psu (hwmon10 hoje) e monta o JSON pro
# Waybar.
#
# USO: psu-monitor.sh [campo1] [campo2] ...
#   Campos válidos: usage, power, temp
#   Sem argumento nenhum = mostra os 3 (comportamento "full").
#   O tooltip SEMPRE mostra tudo, não importa a escolha do pill.
#
# ATENÇÃO — "hwmon10" não é garantido entre boots. Conferir com:
#   for f in /sys/class/hwmon/hwmon*/name; do echo "$f: $(cat "$f")";
#   done | grep corsair
HWMON="/sys/class/hwmon/hwmon9"
ICON="󰚥"

power_uw=$(<"$HWMON/power1_input")
vrm_temp_mc=$(<"$HWMON/temp1_input")

read -r usage_pct power_w vrm_temp_c <<< "$(awk -v p="$power_uw" -v t="$vrm_temp_mc" '
    BEGIN {
        w = p / 1000000
        printf "%.0f %.0f %.0f", (w / 1500 * 100), w, (t / 1000)
    }
')"

declare -A VALUES=(
    [usage]="${usage_pct}%"
    [power]="${power_w}W"
    [temp]="${vrm_temp_c}°C"
)

if [ "$#" -eq 0 ]; then
    fields=(usage power temp)
else
    fields=("$@")
fi

lines=("<span size='large'>$ICON</span>")
for f in "${fields[@]}"; do
    lines+=("${VALUES[$f]}")
done
text=$(printf "%s\n" "${lines[@]}")
text="${text%$'\n'}"

tooltip=$(printf "Corsair HX1500i\nUso: %s%%\nPotência: %sW\nTemp. VRM: %s°C" \
    "$usage_pct" "$power_w" "$vrm_temp_c")

jq -nc --arg text "$text" --arg tooltip "$tooltip" '{text: $text, tooltip: $tooltip}'