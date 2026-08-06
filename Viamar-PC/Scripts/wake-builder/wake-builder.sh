#!/bin/bash
#
#        Title:      wake-builder.sh
#        Brief:
#        Path:       /home/jkyon/ShellScript/Viamar-PC/Scripts/wake-builder/wake-builder.sh
#        Author:     John Kennedy a.k.a. jKyon
#        Created:    2026-08-06
#        Updated:    2026-08-06
#        Notes:
#

MAC="08:bf:b8:04:a3:d4"
IP="192.168.5.50"

echo "🔌 Enviando magic packets..."
for i in {1..5}; do
    wakeonlan "$MAC" > /dev/null 2>&1
    sleep 1
done

echo "⏳ Aguardando Builder responder..."
for i in {1..30}; do
    if nc -z -w1 "$IP" 22 > /dev/null 2>&1; then
        echo "✅ Builder ativo"
        exit 0
    fi
    sleep 1
done

echo "❌ Builder ainda suspenso - tente novamente"
exit 1