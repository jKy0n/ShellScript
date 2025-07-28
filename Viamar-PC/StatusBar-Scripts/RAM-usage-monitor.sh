#!/bin/sh
# Lê MemTotal e MemAvailable diretamente do /proc/meminfo
read total available < <(
  awk '
    /MemTotal:/     { t=$2 }
    /MemAvailable:/ { a=$2 }
    END { print t, a }
  ' /proc/meminfo
)

# Calcula uso em porcentagem (inteiro, de 0 a 99)
used=$(( total - available ))
pct=$(( used * 100 / total ))

# Formata com duas casas, preenchendo com zero se necessário
printf "%2d%%\n" "$pct"