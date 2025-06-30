#!/usr/bin/env bash
#
#
#
# NOTE: Widget de uso de memoria ram
#       memory RAM usage Widget
#
# Lê a memoria e armazena as variáveis
# Read memory and store variables
read Memory_total Memory_used <<< $(free -b | awk '/^Mem:/ {print $2, $3}')
#
# Calcula o percentual de uso de memória
# Calcule a memory usage in percentage
Memory_usage=$( echo " ( $Memory_used * 100 ) / $Memory_total " | bc )
#
# Mostra o valor
# Show value
echo "$Memory_usage%"
