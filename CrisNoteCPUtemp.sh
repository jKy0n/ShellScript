#!/usr/bin/env bash
#
nice -n 19 \
    sensors | \
        awk '/Package id 0:/ { print $4 }' | \
        sed -e 's/^.//' -e 's/....$//' | \
        awk '{sub("$", "ºC", $1)}; 1'
