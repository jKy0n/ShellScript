#!/usr/bin/env bash
#
#        Title:      wake-theseusmachine.sh
#        Brief:
#        Path:       /home/jkyon/ShellScript/CrisNote/tools/wake-theseusmachine/wake-theseusmachine.sh
#        Author:     John Kennedy a.k.a. jKyon
#        Created:    2026-03-26
#        Updated:    2026-08-06
#        Notes:
#

set -eu

MAC="10:7c:61:4f:c8:9b"
BROADCAST="192.168.15.255"
IP="192.168.15.10"

echo "🔌 Enviando magic packets..."
for i in {1..5}; do
    wakeonlan -i "$BROADCAST" "$MAC" > /dev/null 2>&1
    sleep 1
done

echo "⏳ Aguardando TheseusMachine responder..."
for i in {1..30}; do
    if nc -z -w1 "$IP" 22 > /dev/null 2>&1; then
        echo "✅ TheseusMachine ativa"
        exit 0
    fi
    sleep 1
done

echo "❌ TheseusMachine ainda suspensa - tente novamente"
exit 1

