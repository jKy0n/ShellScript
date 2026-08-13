#!/usr/bin/env bash
#
#        Title:      wake-theseusmachine.sh
#        Brief:      Acorda a TheseusMachine via WOL (broadcast local).
#        Path:       /home/jkyon/ShellScript/CrisNote/tools/wake-theseusmachine/wake-theseusmachine.sh
#        Author:     John Kennedy a.k.a. jKyon
#        Created:    2026-03-26
#        Updated:    2026-08-13
#        Notes:
#          Broadcast de WOL não atravessa Tailscale, só funciona dentro da
#          própria LAN do alvo (192.168.15.x). Por isso este script SEMPRE
#          roda fisicamente na Crisnote — o alias `wake-theseusmachine`
#          (definido em aliases.zsh) já faz `ssh crisnote "bash este-script"`
#          antes de chegar aqui. O script em si não precisa saber de onde
#          o usuário chamou o alias original.
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
