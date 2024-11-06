#!/usr/bin/env bash
#
nice -n 19 \
    sensors | \
        awk '/^power total/ { sub(/\..*$/, "", $3); print $3 " W" }'
