#!/usr/bin/env bash
#
nice -n 19 \
    cpupower frequency-info | \
        grep "current CPU frequency" | \
        grep -v "Unable" | \
        awk '{printf "%.1f GHz\n", $4}'
