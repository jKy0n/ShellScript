#!/bin/bash
#
#        Title:      incubadora-dashboard.sh
#        Brief:      Painel do que falta atualizar no parque Gentoo: o que compilar (TheseusMachine e incubadoras) e o que instalar (PCs).
#        Path:       /home/jkyon/ShellScript/TheseusMachine/scripts/incubadora/incubadora-dashboard.sh
#        Author:     John Kennedy a.k.a. jKyon
#        Created:    2026-11-14
#        Updated:    2026-11-14
#        Notes:
#          Roda na TheseusMachine, como usuário (pede o sudo uma vez, pros chroots).
#          De outros PCs, a função zsh "incubadora-dashboard" chega aqui por SSH.
#
#          Consulta tudo ao mesmo tempo com o incubadora-dashboard-probe.sh:
#            - host da TheseusMachine (sudo, pra o qlop ler o emerge.log);
#            - cada chroot de /mnt/incubadora (incubadora.sh <alvo>);
#            - os PCs que instalam binário, por SSH com a chave
#              ~/.ssh/theseusmachine-dashboard-nopass (forced command = probe).
#
#          Tempo estimado: mediana dos builds anteriores de cada [ebuild] (qlop -t,
#          histórico de cada máquina ou chroot) e BIN_SECS por binário. Pacote sem
#          histórico entra como "sem histórico". É estimativa: com --jobs, os
#          builds se sobrepõem.
#
#          Num PC, um [ebuild] que a incubadora dele também tem na fila é
#          "aguardando incubadora" (vira binário depois do upgrade dela); o resto
#          compilaria no próprio PC.
#

set -uo pipefail

SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
PROBE="$SCRIPT_DIR/incubadora-dashboard-probe.sh"
INCUBADORA="$SCRIPT_DIR/incubadora.sh"
BASE="/mnt/incubadora"
SSH_KEY="$HOME/.ssh/theseusmachine-dashboard-nopass"
BIN_SECS=5

# PC que instala binário -> host SSH e chroot que o alimenta
PCS=("Viamar-PC" "Builder")
declare -A PC_SSH=([Viamar-PC]=viamar-pc [Builder]=builder)
declare -A PC_ALVO=([Viamar-PC]=viamar-pc [Builder]=builder)

if [[ -t 1 ]]; then
    B=$'\e[1m' D=$'\e[2m' R=$'\e[0m' RED=$'\e[31m' GRN=$'\e[32m' YEL=$'\e[33m' CYA=$'\e[36m'
else
    B= D= R= RED= GRN= YEL= CYA=
fi

TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

sudo -n true 2>/dev/null || sudo -v || exit 1

alvos=()
for d in "$BASE"/*/; do
    [[ -d "$d/etc/portage" ]] && alvos+=("$(basename "$d")")
done

# ---------------------------------------------------------------- coleta
sudo sh "$PROBE" >"$TMP/tm" 2>&1 &
for t in "${alvos[@]}"; do
    if machinectl list --no-legend 2>/dev/null | grep -qw "$t"; then
        echo BUSY >"$TMP/alvo-$t"
    else
        # O nspawn devolve as linhas com \r (pty): sem o tr, o parse não casa nada.
        sudo "$INCUBADORA" "$t" sh -c "$(cat "$PROBE")" 2>&1 </dev/null | tr -d '\r' >"$TMP/alvo-$t" &
    fi
done
ssh_opts=(-o BatchMode=yes -o ConnectTimeout=5)
[[ -r "$SSH_KEY" ]] && ssh_opts+=(-i "$SSH_KEY" -o IdentitiesOnly=yes)
for pc in "${PCS[@]}"; do
    # Com o forced command o "sh -s" é ignorado; sem ele, o probe vai pelo stdin.
    ssh "${ssh_opts[@]}" "${PC_SSH[$pc]}" sh -s <"$PROBE" >"$TMP/pc-$pc" 2>&1 \
        || echo OFFLINE >>"$TMP/pc-$pc" &
done

[[ -t 1 ]] && printf '  ⏳ consultando TheseusMachine, incubadoras e PCs...'
wait
[[ -t 1 ]] && printf '\r\e[K'

# ---------------------------------------------------------------- parse
field()    { sed -n "s/^$2=//p" "$1" | head -1; }
emerge_of() { sed -n '/^---EMERGE---$/,/^---QLOP---$/p' "$1"; }
count()    { emerge_of "$1" | grep -cE "^\[$2" ; }
size_kib() { local s; s=$(emerge_of "$1" | sed -n 's/.*Size of downloads: \([0-9]*\) KiB.*/\1/p' | tail -1); echo "${s:-0}"; }
ok_probe() { grep -q '^---EMERGE---$' "$1" && emerge_of "$1" | grep -q '^Total: '; }
skipped()  { emerge_of "$1" | grep -q 'have been skipped due to a dependency conflict'; }
atoms()    {
    emerge_of "$1" | sed -nE "s/^\[($2)[^]]*\] ([^ ]*).*/\2/p" \
        | sed -E 's/::.*//; s/:[^/]*$//; s/-[0-9]+(\.[0-9]+)*[a-z]?((_alpha|_beta|_pre|_rc|_p)[0-9]*)*(-r[0-9]+)?$//'
}

# stdin = cat/pn; saída "segundos sem_historico" (mediana do qlop do probe $1)
estimate() {
    gawk -v f="$1" '
        BEGIN {
            while ((getline l < f) > 0) {
                if (l == "---QLOP---") { q = 1; continue }
                if (q && l ~ / >>> /) {
                    sub(/^[0-9]+ >>> /, "", l); split(l, a, ": ")
                    t[a[1]] = t[a[1]] " " a[2]
                }
            }
        }
        NF {
            if ($0 in t) {
                m = split(substr(t[$0], 2), v, " "); asort(v)
                s += (m % 2) ? v[(m + 1) / 2] : (v[m / 2] + v[m / 2 + 1]) / 2
            } else u++
        }
        END { printf "%d %d\n", s, u }'
}

hm() { local m=$((($1 + 59) / 60)); printf '%d:%02d' $((m / 60)) $((m % 60)); }
tempo() { # segundos sem_historico
    local s="~$(hm "$1")"
    (($2 > 0)) && s+=" ${D}(+$2 sem histórico)${R}"
    printf '%s' "$s"
}
linha() { printf '  %s %-24s %s\n' "$1" "$2" "$3"; }

total_compilar=0 total_instalar=0 total_kib=0 total_s=0
alertas=()

alerta_lista() { # nome arquivo
    local lst
    lst=$(atoms "$2" '(ebuild|binary)')
    grep -qx 'sys-devel/gcc' <<<"$lst" && alertas+=("${YEL}⚠️  GCC na lista ($1): siga a ordem do GENTOO-UPDATE.md, \"GCC novo\"${R}")
    grep -qE '^sys-kernel/.*kernel' <<<"$lst" && alertas+=("🐧 kernel novo em $1: reboot depois do upgrade")
    skipped "$2" && alertas+=("${YEL}⚠️  $1: atualizações puladas por conflito (rode o update e leia o fim)${R}")
    # News só das máquinas: as do chroot repetem as do host e ninguém lê lá dentro.
    local n; n=$(field "$2" NEWS)
    [[ "$1" != incubadora* && "${n:-0}" =~ ^[1-9] ]] && alertas+=("📰 $1: $n news não lidas (eselect news read)")
}

tree_tm=$(field "$TMP/tm" TREE)
tree_txt=$(date -d "$tree_tm" '+%d/%m %H:%M' 2>/dev/null || echo '?')
desalinhados=()

# ---------------------------------------------------------------- saída
echo
printf '  🧬 %sIncubadora Dashboard%s%*s%s\n' "$B" "$R" 26 '' "$(date '+%a %d/%m %H:%M')"

# ---- compilar
compilar_linhas=()
if ok_probe "$TMP/tm"; then
    n=$(count "$TMP/tm" 'ebuild')
    read -r s u < <(atoms "$TMP/tm" ebuild | estimate "$TMP/tm")
    total_compilar=$((total_compilar + n)) total_s=$((total_s + s))
    total_kib=$((total_kib + $(size_kib "$TMP/tm")))
    if ((n == 0)); then st="${GRN}✅ em dia${R}"; else st="${B}$n${R} pacotes    $(tempo "$s" "$u")"; fi
    alerta_lista TheseusMachine "$TMP/tm"
else
    st="${RED}❗ emerge -p falhou${R}"
fi
compilar_linhas+=("$(linha '🖥️ ' TheseusMachine "$st")")

declare -A fila_alvo
for t in "${alvos[@]}"; do
    f="$TMP/alvo-$t"
    if [[ "$(cat "$f")" == BUSY ]]; then
        st="${CYA}🔄 emerge rodando agora${R}"
    elif ok_probe "$f"; then
        n=$(count "$f" 'ebuild')
        fila_alvo[$t]=$(atoms "$f" ebuild)
        read -r s u < <(atoms "$f" ebuild | estimate "$f")
        total_compilar=$((total_compilar + n)) total_s=$((total_s + s))
        total_kib=$((total_kib + $(size_kib "$f")))
        if ((n == 0)); then st="${GRN}✅ em dia${R}"; else st="${B}$n${R} pacotes    $(tempo "$s" "$u")"; fi
        alerta_lista "incubadora $t" "$f"
    else
        st="${RED}❗ emerge -p falhou${R}"
    fi
    compilar_linhas+=("$(linha '🧪' "incubadora $t" "$st")")
done

# ---- instalar
instalar_linhas=()
for pc in "${PCS[@]}"; do
    f="$TMP/pc-$pc"
    t=${PC_ALVO[$pc]}
    if grep -q '^OFFLINE$' "$f" || ! grep -q '^---EMERGE---$' "$f"; then
        st="${D}⚫ offline${R}"
    elif ! ok_probe "$f"; then
        st="${RED}❗ emerge -p falhou${R}"
    else
        nb=$(count "$f" 'binary')
        espera=0 local_n=0 local_atoms=""
        while read -r a; do
            [[ -z "$a" ]] && continue
            if grep -qx -- "$a" <<<"${fila_alvo[$t]:-}"; then
                espera=$((espera + 1))
            else
                local_n=$((local_n + 1)) local_atoms+="$a"$'\n'
            fi
        done < <(atoms "$f" ebuild)
        read -r s u < <(printf '%s' "$local_atoms" | estimate "$f")
        s=$((s + (nb + espera) * BIN_SECS))
        n=$((nb + espera + local_n))
        total_instalar=$((total_instalar + n)) total_s=$((total_s + s))
        total_kib=$((total_kib + $(size_kib "$f")))
        if ((n == 0)); then
            st="${GRN}✅ Atualizado!${R}"
        else
            st="${B}$nb${R} binários"
            ((espera > 0)) && st+=" · ${CYA}$espera aguardando incubadora${R}"
            ((local_n > 0)) && st+=" · ${YEL}⚠️  $local_n vão compilar local${R}"
            st+="    $(tempo "$s" "$u")"
        fi
        [[ "$(field "$f" TREE)" != "$tree_tm" ]] && desalinhados+=("$pc")
        alerta_lista "$pc" "$f"
    fi
    instalar_linhas+=("$(linha "$([[ $pc == Builder ]] && echo '🗄️ ' || echo '💻')" "$pc" "$st")")
done
instalar_linhas+=("$(linha '💼' CrisNote "${D}❌ ainda não inserido${R}")")

if ((${#desalinhados[@]} == 0)); then
    printf '  🌳 Árvore: %s (TheseusMachine) · %stodos alinhados ✅%s\n' "$tree_txt" "$GRN" "$R"
else
    printf '  🌳 Árvore: %s (TheseusMachine) · %s⚠️  outra árvore em: %s (portage-sync)%s\n' \
        "$tree_txt" "$YEL" "${desalinhados[*]}" "$R"
fi

sep() { printf '\n  %s── %s %s%s\n' "$D" "$1" "$(printf '─%.0s' $(seq $((54 - ${#1}))))" "$R"; }

sep Compilar;  printf '%s\n' "${compilar_linhas[@]}"
sep Instalar;  printf '%s\n' "${instalar_linhas[@]}"
sep Total
gb=$(gawk -v k="$total_kib" 'BEGIN { if (k >= 1048576) printf "%.1f GB", k / 1048576; else printf "%d MB", k / 1024 }' | tr . ,)
total=$((total_compilar + total_instalar))
if ((total == 0)); then
    printf '  %s✅ Tudo em dia!%s\n' "$GRN" "$R"
else
    printf '  %s%d pacotes%s (%d compilar · %d instalar) · %s · ~%s\n' \
        "$B" "$total" "$R" "$total_compilar" "$total_instalar" "$gb" "$(hm "$total_s")"
fi
for a in "${alertas[@]}"; do printf '  %s\n' "$a"; done
echo
