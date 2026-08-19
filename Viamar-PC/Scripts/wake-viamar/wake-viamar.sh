#!/bin/bash
#
#        Title:      wake-viamar.sh
#        Brief:      Acorda o Viamar-PC via WOL (broadcast local).
#        Path:       /home/jkyon/ShellScript/Viamar-PC/Scripts/wake-viamar/wake-viamar.sh
#        Author:     John Kennedy a.k.a. jKyon
#        Notes:
#          Broadcast de WOL não atravessa Tailscale, só funciona dentro da
#          própria LAN do alvo (192.168.5.x). Por isso este script SEMPRE
#          roda fisicamente no Builder — mesmo padrão do wake-builder.sh.
#

MAC="3c:7c:3f:79:70:42"
BROADCAST="192.168.5.255"
IP="192.168.5.110"

echo "🔌 Enviando magic packets..."
for i in {1..5}; do
    wakeonlan -i "$BROADCAST" "$MAC" > /dev/null 2>&1
    sleep 1
done

echo "⏳ Aguardando Viamar-PC responder..."
for i in {1..30}; do
    if nc -z -w1 "$IP" 22 > /dev/null 2>&1; then
        echo "✅ Viamar-PC ativo"
        exit 0
    fi
    sleep 1
done

echo "❌ Viamar-PC ainda suspenso - tente novamente"
exit 1
