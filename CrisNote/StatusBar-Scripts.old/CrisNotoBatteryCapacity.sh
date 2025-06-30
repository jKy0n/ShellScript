#!/usr/bin/env bash
#
nice -n 19 \
    cat /sys/class/power_supply/BAT1/capacity | \
    awk '{sub ("$", "%", $1)}; 1'
