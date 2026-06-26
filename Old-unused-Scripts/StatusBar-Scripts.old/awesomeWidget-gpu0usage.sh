#!/usr/bin/env bash
#
nice -n 19 \
    radeontop -d - -l 1 | \
        grep 'gpu' | \
        awk '{printf "%2.0f%\n", $5}'