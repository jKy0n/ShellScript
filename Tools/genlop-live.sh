#!/usr/bin/env bash
#
# genlop-live.sh — painel "ao vivo" de genlop pro zellij (portage-panel.kdl).
# Só reexecuta o genlop enquanto o emerge está de fato rodando; quando
# ocioso, só reconfere em intervalo longo sem redesenhar nem gerar
# processos novos — evita poluir o htop com o watch genlop cru.
#
# Duas medidas extras contra o "piscar" de tela:
#   1. O genlop roda ANTES do clear (ele demora um instante pra ler o
#      emerge.log inteiro) — assim a tela velha some só no instante em
#      que a nova já está pronta, sem intervalo em branco.
#   2. Só limpa/redesenha se o conteúdo realmente mudou. Isso evita
#      redesenhos inúteis quando "emerge" está ativo por outro motivo
#      que não uma compilação (ex.: um emerge --sync), caso em que o
#      genlop -c fica repetindo "no working merge found" sem nada de
#      novo pra mostrar.

INTERVALO_ATIVO="${GENLOP_LIVE_INTERVALO_ATIVO:-3}"
INTERVALO_OCIOSO="${GENLOP_LIVE_INTERVALO_OCIOSO:-30}"

ultima_saida=""

mostrar() {
    local saida
    saida="$(nice --adjustment=19 genlop -ci 2>&1)"
    if [[ "$saida" != "$ultima_saida" ]]; then
        clear
        printf '[%s] genlop -ci\n\n%s\n' "$(date '+%H:%M:%S')" "$saida"
        ultima_saida="$saida"
    fi
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
