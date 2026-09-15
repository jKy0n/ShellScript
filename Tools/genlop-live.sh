#!/usr/bin/env bash
#
# genlop-live.sh — painel "ao vivo" de genlop pro zellij (portage-panel.kdl).
# Só reexecuta o genlop enquanto o emerge está de fato rodando; quando
# ocioso, só reconfere em intervalo longo sem redesenhar nem gerar
# processos novos — evita poluir o htop com o watch genlop cru.

INTERVALO_ATIVO="${GENLOP_LIVE_INTERVALO_ATIVO:-3}"
INTERVALO_OCIOSO="${GENLOP_LIVE_INTERVALO_OCIOSO:-30}"

mostrar() {
    clear
    printf '[%s] genlop -ci\n\n' "$(date '+%H:%M:%S')"
    nice --adjustment=19 genlop -ci
}

precisa_redesenhar=1   # garante 1 desenho já na primeira iteração
while true; do
    if pgrep -x emerge >/dev/null; then
        mostrar
        precisa_redesenhar=1   # se parar depois, ainda falta 1 redesenho final
        sleep "$INTERVALO_ATIVO"
    else
        if ((precisa_redesenhar)); then
            mostrar
            precisa_redesenhar=0
        fi
        sleep "$INTERVALO_OCIOSO"
    fi
done
