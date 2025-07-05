#!/bin/sh

    sensors | \
#   Extrai temperatura do VRM da PSU
        awk '/corsairpsu-hid-[0-9]+-[0-9]+/,/vrm/ \
        {if (/vrm/) \
        {gsub(/^\+|\.[0-9]+°C$/, "", $3); \
        print $3 "ºC"}}'