#!/usr/bin/env bash
#

# Capacidade nominal da PSU
MAX_POWER=1500

# Captura o consumo total em watts e calcula o uso percentual
nice -n 19 \
    sensors | \
        awk -v max_power="$MAX_POWER" '/^power total/ {
            sub(/\..*$/, "", $3); # Remove valores decimais do consumo
            power=$3;               # Consumo total em W
            percent=int((power / max_power) * 100); # Calcula o uso percentual como inteiro
            printf "%d%% (%d W)\n", percent, power; # Exibe uso percentual e consumo em W
        }'

#
# NOTE: Versão antiga simples
#
# nice -n 19 \
#     sensors | \
#         awk '/^power total/ { sub(/\..*$/, "", $3); print $3 " W" }'
