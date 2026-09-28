#!/usr/bin/env bash
#
# stress-thermal.sh — teste de estresse térmico padrão do parque
#
# Método (condições, colunas, comparação): ~/.jkyon-ai-context/STRESS-TEST.md
#
# Fases: idle 60s → carga 600s (stress-ng --verify) → resfriamento 120s,
# amostra a cada 2s (hwmon k10temp + média de scaling_cur_freq das CPUs online).
# CSV bruto em /tmp (snapshot, não versionado).
#
# Uso:   stress-thermal.sh
# Smoke: IDLE=6 LOAD=10 COOL=6 stress-thermal.sh   (só pra validar a coleta)

set -uo pipefail

IDLE=${IDLE:-60}
LOAD=${LOAD:-600}
COOL=${COOL:-120}
STEP=2

host=$(uname -n)
stamp=$(date +%Y%m%d-%H%M)
csv=/tmp/stress-thermal-$host-$stamp.csv
log=/tmp/stress-thermal-$host-$stamp.stress-ng.log

# --- sensores ---------------------------------------------------------------
hw=""
for h in /sys/class/hwmon/hwmon*; do
  [[ $(<"$h/name") == k10temp ]] && { hw=$h; break; }
done
[[ -n $hw ]] || { echo "❌ hwmon k10temp não encontrado" >&2; exit 1; }
command -v stress-ng >/dev/null || { echo "❌ stress-ng não instalado" >&2; exit 1; }

mapfile -t tin < <(ls "$hw"/temp*_input | sort -V)
labels=()
for f in "${tin[@]}"; do
  l=${f%_input}_label
  if [[ -r $l ]]; then labels+=("$(<"$l")"); else labels+=("$(basename "${f%_input}")"); fi
done

# sem fork por leitura (read builtin) — com 30+ CPUs sob carga, fork atrasa a cadência
sample() {  # $1 = fase
  local t=$(( EPOCHSECONDS - t0 )) row v r sum=0 n=0 f
  row="$t,$1"
  for f in "${tin[@]}"; do
    read -r v < "$f"; r=$(( (v + 50) / 100 ))
    row+=",$((r / 10)).$((r % 10))"
  done
  for f in /sys/devices/system/cpu/cpu[0-9]*/cpufreq/scaling_cur_freq; do
    read -r v < "$f" 2>/dev/null || continue   # CPU offline → EBUSY
    sum=$((sum + v)); n=$((n + 1))
  done
  echo "$row,$(( n ? sum / n / 1000 : 0 ))" >> "$csv"
}

tick() {  # dorme até o próximo múltiplo de STEP desde t0
  local next=$(( t0 + ((EPOCHSECONDS - t0) / STEP + 1) * STEP ))
  sleep $(( next - EPOCHSECONDS ))
}

# --- cabeçalho --------------------------------------------------------------
offline_before=$(cat /sys/devices/system/cpu/offline)
epp=$(cat /sys/devices/system/cpu/cpu0/cpufreq/energy_performance_preference 2>/dev/null || echo "n/a")
ncpu=$(nproc)
cmd=(stress-ng --cpu "$ncpu" --vm 2 --vm-bytes 3G --verify --timeout "${LOAD}s" --metrics-brief)

echo "t,phase,$(IFS=,; echo "${labels[*]}"),freq_mhz" > "$csv"
start_epoch=$EPOCHSECONDS
start_h=$(date '+%F %T %z')
t0=$start_epoch

echo "🌡️  $host — $start_h"
echo "   CPU offline: ${offline_before:-nenhuma} | nproc: $ncpu | EPP: $epp | sensores: ${labels[*]}"
echo "   Fases: idle ${IDLE}s → carga ${LOAD}s → resfriamento ${COOL}s"
echo "   Carga: ${cmd[*]}"
echo "   CSV: $csv"

# --- fases ------------------------------------------------------------------
for ((i = 0; i < IDLE / STEP; i++)); do sample idle; tick; done

"${cmd[@]}" > "$log" 2>&1 &
pid=$!
while kill -0 "$pid" 2>/dev/null; do sample load; tick; done
wait "$pid"; rc=$?

for ((i = 0; i < COOL / STEP; i++)); do tick; sample cool; done

# --- resumo -----------------------------------------------------------------
offline_after=$(cat /sys/devices/system/cpu/offline)

summary=$(awk -F, '
  NR == 1 { for (i = 3; i < NF; i++) { if ($i == "Tctl") tc = i; if ($i ~ /^Tccd/) ccd[i] = 1 } if (!tc) tc = 3; next }
  $2 == "idle" { is += $tc; in_++ }
  $2 == "load" {
    if (!ls_) ls_ = $1; le = $1; n++
    t[n] = $1; v[n] = $tc; fs += $NF
    if ($tc > pk) pk = $tc
    for (c in ccd) if ($c > cm) cm = $c
    if (!at4 && $1 - ls_ >= 240) at4 = $tc
  }
  $2 == "cool" { cl = $tc }
  END {
    for (i = 1; i <= n; i++) if (t[i] >= le - 60) { ps += v[i]; pn++ }
    printf "%.1f|%s|%.1f|%.1f|%s|%d|%.1f|%d\n", is / in_, (at4 ? sprintf("%.1f", at4) : "—"),
      pk, ps / pn, (length(ccd) ? sprintf("%.1f", cm) : "—"), fs / n, cl, le - ls_ + 2
  }' "$csv" | tr . ,)
IFS='|' read -r idle at4 peak plat ccdmax freq cool dur <<< "$summary"
deg() { [[ $1 == — ]] && echo "—" || echo "$1°C"; }

echo
echo "── stress-ng (exit $rc) ──"
grep -E 'passed:|failed:|skipped:|untrustworthy|error|fail' "$log" | sed 's/^stress-ng: //'

echo
echo "── journal (kernel) desde o início ──"
if j=$(journalctl -k --since "@$start_epoch" --no-pager -q 2>/dev/null | grep -iE 'thermal|mce|throttl|hardware error'); then
  echo "$j"
else
  echo "nenhum evento thermal/mce/throttl/hardware error"
fi

echo
echo "── rasdaemon ──"
db=/var/lib/rasdaemon/ras-mc_event.db
if command -v sqlite3 >/dev/null && [[ -r $db ]]; then
  echo "mce_record desde $start_h: $(sqlite3 "file:$db?mode=ro" "select count(*) from mce_record where timestamp >= '$start_h';")"
else
  echo "n/a (sem rasdaemon/sqlite3)"
fi

echo
echo "── CPU offline ──"
echo "antes: ${offline_before:-nenhuma} | depois: ${offline_after:-nenhuma}"

echo
echo "── linha pra temperatura-geral.md ──"
echo "| Data | Duração | Ambiente | Tctl idle | Tctl @4min | Tctl pico | Platô (últ. 60s) | Tccd máx | Freq. média carga | Resfriamento (+$((COOL / 60))min) | Pasta / cura | Observações |"
echo "| ${start_h%% *} | $((dur / 60))min | ? | ${idle}°C | $(deg "$at4") | ${peak}°C | ${plat}°C | $(deg "$ccdmax") | ${freq} MHz | ${cool}°C | ? | stress-ng exit $rc; EPP \`$epp\` |"
echo
echo "CSV: $csv"
echo "log: $log"
