#!/usr/bin/env bash
#
nice -n 19 \
    cat /sys/class/hwmon/hwmon5/freq1_input | \
        sed -e 's/......$//' | \
        awk '{printf "%4s MHz\n", $1}'
