#!/usr/bin/env bash
#
# Suaviza o processo
nice -n 19 \
#   Chama sensores do sistema
    sensors | \
#       Detecta GPU0 e extrai temperatura
        awk '/amdgpu-pci-0b00/,/edge/ {if (/edge/) {gsub(/^\+|\.[0-9]+°C$/, "", $2); print $2 "ºC"}}'
#       Exemplo: 45ºC        