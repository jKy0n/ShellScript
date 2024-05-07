#!/usr/bin/env bash
#
nice -n 19 \
    cat /sys/class/hwmon/hwmon5/temp1_input | \
        sed -e 's/...$//' | \
        awk '{sub("$", "°C", $1)}; 1'