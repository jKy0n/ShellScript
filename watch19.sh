#!/usr/bin/env bash
#
nice -n 19 \
    watch -n 1 --color \
    $1 $2 $3 $4
