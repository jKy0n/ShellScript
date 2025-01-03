#!/usr/bin/env bash
#
nice --adjustment=19 \
    watch --color --differences --interval 1 --color \
    $1 $2 $3 $4
