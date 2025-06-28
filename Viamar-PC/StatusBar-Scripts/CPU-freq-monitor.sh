#!/bin/sh
# Frequência média de todos os núcleos em MHz (converte para GHz ao final)

avg=$(awk '/cpu MHz/ { total += $4; n++ }
           END { if (n>0) printf "%.1f\n", (total/n)/1000 }' /proc/cpuinfo)

echo "${avg}GHz"