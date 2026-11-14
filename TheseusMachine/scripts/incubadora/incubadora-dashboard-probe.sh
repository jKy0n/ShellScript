#!/bin/sh
#
#        Title:      incubadora-dashboard-probe.sh
#        Brief:      Coleta, numa máquina Gentoo (ou num chroot da incubadora), o que o incubadora-dashboard mostra.
#        Path:       /home/jkyon/ShellScript/TheseusMachine/scripts/incubadora/incubadora-dashboard-probe.sh
#        Author:     John Kennedy a.k.a. jKyon
#        Created:    2026-11-14
#        Updated:    2026-11-14
#        Notes:
#          POSIX sh de propósito: o dashboard roda este mesmo arquivo no host da
#          TheseusMachine, dentro de cada chroot (incubadora.sh <alvo> sh -c "...")
#          e nos PCs que instalam binário, por SSH. Nos PCs ele é o forced command
#          da chave theseusmachine-dashboard (authorized_keys com restrict), então
#          essa chave só serve pra isso.
#
#          Sem root: emerge -p e eselect news leem sem privilégio. O qlop precisa
#          ler o /var/log/emerge.log (0660 portage): nos chroots o probe roda como
#          root; nos PCs a previsão some (o dashboard mostra "?"), o que só pesa
#          nos [ebuild] que o PC compilaria sozinho.
#
#          Saída (o dashboard faz o parse):
#            HOST=… TREE=… NEWS=… RC=…
#            ---EMERGE---   saída do emerge -pvuDN @world
#            ---QLOP---     duração (segundos) de cada build anterior dos [ebuild] da
#                           lista; o dashboard usa a mediana. O "qlop -p" não serve:
#                           só prevê com várias amostras e pesa os builds que
#                           esperaram CPU com --jobs (platformdirs "1935 s").
#

export LC_ALL=C

printf 'HOST=%s\n' "$(hostname)"
printf 'TREE=%s\n' "$(cat /var/db/repos/gentoo/metadata/timestamp.chk 2>/dev/null)"
printf 'NEWS=%s\n' "$(eselect news count new 2>/dev/null || echo 0)"

out=$(emerge -pvuDN --color=n @world 2>&1)
printf 'RC=%s\n' "$?"

echo '---EMERGE---'
printf '%s\n' "$out"

# cat/pn de cada [ebuild] (sem versão, slot e repo), que é o que o qlop entende.
# Versão tirada por regex e não pelo qatom, que se perde com versão em data
# (media-fonts/noto-20261101).
echo '---QLOP---'
atoms=$(printf '%s\n' "$out" \
    | sed -n 's/^\[ebuild[^]]*\] \([^ ]*\).*/\1/p' \
    | sed -E 's/::.*//; s/:[^/]*$//; s/-[0-9]+(\.[0-9]+)*[a-z]?((_alpha|_beta|_pre|_rc|_p)[0-9]*)*(-r[0-9]+)?$//')
if [ -n "$atoms" ]; then
    # shellcheck disable=SC2086
    qlop -t -M -C $atoms 2>/dev/null
fi
exit 0
