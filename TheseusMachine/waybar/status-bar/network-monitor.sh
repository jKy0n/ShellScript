#!/bin/bash
# O connectivity-checker embutido do NetworkManager tem um bug
# reproduzível nesta máquina: reporta PORTAL ("unexpected short
# response") mesmo com resposta HTTP perfeita confirmada por curl,
# testado contra 3 endpoints diferentes (HTTP e HTTPS). Não é o
# endpoint — é o parser interno do NM em requests concorrentes
# IPv4/IPv6. Também herda travamentos de outras interfaces (Tailscale,
# Docker) mesmo unmanaged, porque o polling do NM não respeita esse
# status. Decisão: bypassa o NM por completo, probe HTTP direto via
# curl — mesma ferramenta que confirmou internet ok em todo teste
# manual desta sessão de debug.
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 \
    https://connectivitycheck.gstatic.com/generate_204)

if [ "$HTTP_CODE" = "204" ]; then
    TEXT=""
    CLASS=""
    TOOLTIP="Internet OK"
elif [ -n "$HTTP_CODE" ] && [ "$HTTP_CODE" != "000" ]; then
    TEXT="<span size='x-large'></span>"
    CLASS="limited"
    TOOLTIP="Rede responde, mas sem saída normal pra internet (HTTP $HTTP_CODE)"
else
    TEXT="<span size='x-large'>&#xf0525;</span>"
    CLASS="disconnected"
    TOOLTIP="Sem conexão de rede"
fi

jq -nc --arg text "$TEXT" --arg class "$CLASS" --arg tooltip "$TOOLTIP" \
    '{text:$text, class:$class, tooltip:$tooltip}'