#!/usr/bin/env bash
#
SYSTEMD_COLORS=always \
SYSTEMD_PAGER=cat \
#
nice --adjustment=19 \
    watch --color --differences --interval 1 \
    "$@"
