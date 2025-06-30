#!/usr/bin/env bash
#
nice -n 19 \
    cat /sys/class/drm/card0/device/gpu_busy_percent | \
        awk '{printf "%2.0f%\n", $1}'