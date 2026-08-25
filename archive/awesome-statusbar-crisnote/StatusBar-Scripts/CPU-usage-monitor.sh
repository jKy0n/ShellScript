#!/bin/sh

PREV_IDLE=$(awk '/^cpu / {print $5}' /proc/stat)
PREV_TOTAL=$(awk '/^cpu / {sum=0; for(i=2;i<=NF;i++) sum+=$i; print sum}' /proc/stat)
sleep 0.5
IDLE=$(awk '/^cpu / {print $5}' /proc/stat)
TOTAL=$(awk '/^cpu / {sum=0; for(i=2;i<=NF;i++) sum+=$i; print sum}' /proc/stat)

DIFF_IDLE=$((IDLE - PREV_IDLE))
DIFF_TOTAL=$((TOTAL - PREV_TOTAL))
USAGE=$(( (100 * (DIFF_TOTAL - DIFF_IDLE)) / DIFF_TOTAL ))

# largura mínima 2, preenchida com espaços — sem zeros
printf "%2d%%\n" "$USAGE"
