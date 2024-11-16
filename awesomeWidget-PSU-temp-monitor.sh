#!/usr/bin/env bash
#
# Suaviza o processo
nice --adjustment=19 \
    sensors | \
#   Extrai temperatura do VRM da PSU
        awk '/corsairpsu-hid-3-5/,/vrm/ {if (/vrm/) {gsub(/^\+|\.[0-9]+°C$/, "", $3); print $3 "Cº"}}'
