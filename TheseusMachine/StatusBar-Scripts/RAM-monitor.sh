#!/bin/sh
# filepath: /home/jkyon/ShellScript/TheseusMachine/StatusBar-Scripts/RAM-monitor.sh

# Lê informações de memória diretamente do /proc/meminfo
read total free available swap_total swap_free < <(
  awk '
    /MemTotal:/     { t=$2 }
    /MemFree:/      { f=$2 }
    /MemAvailable:/ { a=$2 }
    /SwapTotal:/    { st=$2 }
    /SwapFree:/     { sf=$2 }
    END { print t, f, a, st, sf }
  ' /proc/meminfo
)

# Calcula memória usada
used=$(( total - free ))

# Converte valores de kB para GB (com precisão de 2 casas decimais)
to_gb() {
  awk -v kb="$1" 'BEGIN { printf "%.2f", kb / 1024 / 1024 }'
}

TOTAL=$(to_gb "$total")
USED=$(to_gb "$used")
FREE=$(to_gb "$free")
AVAILABLE=$(to_gb "$available")

# Calcula uso em porcentagem
USAGE=$(( used * 100 / total ))
USAGE_AVAILABLE=$(( available * 100 / total ))

# Swap
SWAP_USED=$(( swap_total - swap_free ))
SWAP_USAGE=0
if [ "$swap_total" -gt 0 ]; then
  SWAP_USAGE=$(( SWAP_USED * 100 / swap_total ))
fi
SWAP_TOTAL=$(to_gb "$swap_total")
SWAP_USED=$(to_gb "$SWAP_USED")
SWAP_FREE=$(to_gb "$swap_free")

# Exibe as informações formatadas
echo "
usage_available: ${USAGE_AVAILABLE}
usage: ${USAGE}
available: ${AVAILABLE}
total: ${TOTAL}
used: ${USED}
free: ${FREE}
swap_usage: ${SWAP_USAGE}
swap_total: ${SWAP_TOTAL}
swap_used: ${SWAP_USED}
swap_free: ${SWAP_FREE}
"