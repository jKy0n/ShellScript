#!/bin/bash
#
#        Title:      wake-viamar.sh
#        Brief:      Acorda o Viamar-PC via WOL (broadcast local).
#        Path:       /home/jkyon/ShellScript/Viamar-PC/Scripts/wake-viamar/wake-viamar.sh
#        Author:     John Kennedy a.k.a. jKyon
#        Created:    2026-08-19
#        Updated:    2026-11-10
#        Notes:
#          Broadcast de WOL não atravessa Tailscale, só funciona dentro da
#          própria LAN do alvo (192.168.15.x desde o modem novo, 2026-10-28). Por isso este script SEMPRE
#          roda fisicamente no Builder — mesmo padrão do wake-builder.sh. O
#          alias `wake-viamar` (definido em aliases.zsh) roda direto se já
#          estiver no Builder, ou faz `ssh builder "bash este-script"` antes
#          de chegar aqui.
#

MAC="3c:7c:3f:79:70:42"
BROADCAST="192.168.15.255"
IP="192.168.15.110"

echo "🔌 Enviando magic packets..."
for i in {1..5}; do
    wakeonlan -i "$BROADCAST" "$MAC" > /dev/null 2>&1
    sleep 1
done

echo "⏳ Aguardando Viamar-PC responder..."
for i in {1..30}; do
    # /dev/tcp do bash em vez do nc (o Builder no Gentoo não tem nc)
    if timeout 1 bash -c "</dev/tcp/$IP/22" 2>/dev/null; then
        echo "✅ Viamar-PC ativo"
        exit 0
    fi
    sleep 1
done

echo "❌ Viamar-PC ainda suspenso - tente novamente"
exit 1
