#!/bin/bash
# Fase 4 da TheseusMachine: cifra o /home (btrfs "home" em 3 discos inteiros:
# 860 EVO 500G, A400 240G, HDD 1T) no lugar, com LUKS2, enquanto o jkyon dorme.
# Mesmo método do luks-home.sh do Viamar-PC (2026-10-29), adaptado:
#   - espera o jkyon sair da sessão gráfica (até DEADLINE, padrão 04:00 da
#     madrugada seguinte), sem nada alterar;
#   - fecha a janela do tmp-claude-nopasswd logo depois do logout (o Claude
#     que abriu roda de dentro do /home e morre junto com o usuário);
#   - para o Docker inteiro (borg-ui, loki-stack, atuin-server e os containers
#     do MCP do Grafana fazem bind de caminhos do /home), bees e snapper do
#     /home, o usuário jkyon e os sshfs;
#   - resize -32M por devid, 3 reencrypt em paralelo com a mesma keyfile,
#     crypttab home1/home2/home3 (por devid: o sdX pode trocar de nome; discard
#     só nos SSDs), monta, resize max por devid, religa tudo.
# Rodar de fora do /home (o bash lê o script aos poucos):
#   sudo install -m 0700 luks-home.sh /root/luks-home.sh
#   sudo systemd-run --unit=luks-home /bin/bash /root/luks-home.sh
# Log legível pelo jkyon: /var/log/luks-home.log (progresso por disco a cada 60 s).
set -uo pipefail
LOG=/var/log/luks-home.log
touch "$LOG"; chmod 0644 "$LOG"
exec > >(tee -a "$LOG") 2>&1

MNT=/home
SNAP=/home/.snapshots
FSUUID=c4087d6f-f111-4a65-83d8-0e269329d1b7
KEY=/etc/cryptsetup-keys.d/home.key
BEES=beesd@$FSUUID.service
U=jkyon
NOPASSWD=/home/$U/ShellScript/Tools/tmp-claude-nopasswd/tmp-claude-nopasswd.sh
DEADLINE=${DEADLINE:-04:00}
DL=$(date -d "$DEADLINE" +%s); (( DL <= $(date +%s) )) && DL=$(date -d "tomorrow $DEADLINE" +%s)

log() { echo "[$(date '+%F %T')] $*"; }

religa() {
    log "religando serviços"
    systemctl unmask --runtime home.mount home-.snapshots.mount 2>/dev/null
    mountpoint -q "$SNAP" || mount "$SNAP"
    systemctl start "$BEES" snapper-timeline.timer snapper-cleanup.timer
    systemctl start docker.service && log "docker ok"
    systemctl start borg-ui.service && log "borg-ui ok"
}
die() { log "ABORTADO: $*"; mountpoint -q "$MNT" && religa; exit 1; }

holders() {
    for p in /proc/[0-9]*; do
        { ls -l "$p/fd" 2>/dev/null; cat "$p/maps" 2>/dev/null; readlink "$p/cwd" "$p/root"; } \
            | grep -qE "(^| )$MNT(/| |\$)" && echo "${p#/proc/} $(cat "$p/comm" 2>/dev/null) uid=$(stat -c %u "$p")"
    done
}

# sessão do jkyon no seat0 que não esteja "closing" (processo em background
# deixa a sessão listada como closing depois do logout)
graphical() {
    for s in $(loginctl list-sessions --no-legend | awk -v u=$U '$3==u && $4=="seat0" {print $1}'); do
        [[ $(loginctl show-session "$s" -p State --value) != closing ]] && return 0
    done
    return 1
}

# bytes lidos pelo cryptsetup / tamanho do device, a cada 60 s
progress() {
    local name=$1 pid=$2 size=$3 prev=0 now rd
    while kill -0 "$pid" 2>/dev/null; do
        sleep 60
        rd=$(awk '/^read_bytes/ {print $2}' "/proc/$pid/io" 2>/dev/null) || break
        [[ -z $rd ]] && break
        now=$(( (rd - prev) / 60 / 1048576 )); prev=$rd
        log "progresso $name: $(( rd * 100 / size ))% ($(( rd / 1073741824 ))/$(( size / 1073741824 )) GiB, ${now} MiB/s)"
    done
}

# ---------- checagens (nada alterado até aqui) ----------
[[ -x /usr/lib/systemd/system-generators/systemd-cryptsetup-generator ]] \
    || { log "ABORTADO: systemd sem USE=cryptsetup; nada foi alterado"; exit 1; }
[[ $(findmnt -no UUID "$MNT") == "$FSUUID" ]] || { log "ABORTADO: $MNT não é o btrfs $FSUUID; nada foi alterado"; exit 1; }

# devid → device (btrfs filesystem show lista "devid N size … path /dev/sdX")
declare -A DEVS
while read -r id dev; do DEVS[$id]=$dev; done < <(btrfs filesystem show "$MNT" | awk '/devid/ {print $2, $NF}')
[[ ${#DEVS[@]} -eq 3 ]] || { log "ABORTADO: esperava 3 devices no $MNT, achei ${#DEVS[@]}; nada foi alterado"; exit 1; }
for id in 1 2 3; do
    d=${DEVS[$id]:-}
    [[ -b $d && $(blkid -s TYPE -o value "$d") == btrfs ]] \
        || { log "ABORTADO: devid $id ($d) não é um btrfs em disco; nada foi alterado"; exit 1; }
    log "devid $id: $d ($(lsblk -dno MODEL,SIZE "$d" | xargs), rota=$(lsblk -dno ROTA "$d" | xargs))"
done

log "início; esperando o $U sair da sessão gráfica (até $(date -d @"$DL" '+%F %H:%M'))"
until ! graphical; do
    (( $(date +%s) > DL )) && { log "ABORTADO: sessão ainda aberta no prazo; nada foi alterado"; exit 1; }
    sleep 15
done
log "sessão fechada"
[[ -x $NOPASSWD ]] && "$NOPASSWD" off && log "janela do tmp-claude-nopasswd fechada"

SUBS=$(btrfs subvolume list "$MNT" | wc -l); log "subvolumes antes: $SUBS"
USED=$(df -B1 --output=used "$MNT" | tail -1); log "usado antes: $(( USED / 1073741824 )) GiB"

log "parando docker, borg-ui, bees, snapper e o usuário $U"
# mascarar os mounts em runtime pra nada remontar o /home na janela (no Viamar,
# o borg-ui reiniciou sozinho e remontou o /home na 1ª tentativa)
systemctl mask --runtime home.mount home-.snapshots.mount
trap 'systemctl unmask --runtime home.mount home-.snapshots.mount 2>/dev/null' EXIT
systemctl stop borg-ui.service
systemctl stop docker.socket docker.service containerd.service
systemctl stop snapper-timeline.timer snapper-cleanup.timer snapper-timeline.service snapper-cleanup.service "$BEES"
loginctl terminate-user "$U"
systemctl stop user@1000.service
umount /mnt/crisnote /mnt/viamar-pc 2>/dev/null

for i in $(seq 20); do
    h=$(holders); [[ -z $h ]] && break
    log "ainda há processos no $MNT (tentativa $i):"; echo "$h"
    loginctl terminate-user "$U" 2>/dev/null
    sleep 15
done
[[ -n $h ]] && die "processos não saíram do $MNT; nada foi alterado"

log "keyfile $KEY"
install -d -m 0700 /etc/cryptsetup-keys.d
[[ -e $KEY ]] || (umask 077; dd if=/dev/urandom of="$KEY" bs=512 count=1 status=none)
chmod 0400 "$KEY"

log "encolhendo o btrfs em 32M em cada devid e desmontando"
for id in 1 2 3; do
    btrfs filesystem resize "$id:-32M" "$MNT" || {
        for j in 1 2 3; do btrfs filesystem resize "$j:max" "$MNT"; done
        die "resize do devid $id falhou; nada foi alterado"; }
done
sync
umount "$SNAP" 2>/dev/null
for i in $(seq 10); do
    mountpoint -q "$MNT" || break
    umount "$MNT" && continue
    log "umount ocupado (tentativa $i):"; holders
    sleep 3
done
remonta() { mount "$MNT" && for j in 1 2 3; do btrfs filesystem resize "$j:max" "$MNT"; done; }
mountpoint -q "$MNT" && { for j in 1 2 3; do btrfs filesystem resize "$j:max" "$MNT"; done; die "umount falhou; resize revertido"; }
# algum serviço pode ter montado o btrfs na namespace dele
for id in 1 2 3; do
    ns=$(cat /proc/[0-9]*/mountinfo 2>/dev/null | awk -v d="${DEVS[$id]}" '$0 ~ " "d" " {print $5}' | sort | uniq -c)
    [[ -n $ns ]] && { echo "$ns"; systemctl unmask --runtime home.mount; remonta; die "${DEVS[$id]} ainda montado em outra namespace; remontado sem cifra"; }
done

log "cryptsetup reencrypt --encrypt nos 3 discos em paralelo"
declare -A CPID
for id in 1 2 3; do
    d=${DEVS[$id]}
    cryptsetup reencrypt --encrypt --type luks2 --reduce-device-size 32M \
        --label "THESEUS_HOME${id}_LUKS" --key-file "$KEY" --batch-mode "$d" &
    CPID[$id]=$!
    progress "home$id" "${CPID[$id]}" "$(blockdev --getsize64 "$d")" &
done
FAIL=()
for id in 1 2 3; do
    wait "${CPID[$id]}"; rc=$?
    log "home$id (${DEVS[$id]}): reencrypt terminou, rc=$rc"
    (( rc == 0 )) || FAIL+=("$id")
done
if (( ${#FAIL[@]} )); then
    started=0
    for id in 1 2 3; do cryptsetup isLuks "${DEVS[$id]}" && started=1; done
    if (( ! started )); then
        systemctl unmask --runtime home.mount
        remonta; die "nenhum reencrypt começou; /home remontado sem cifra"
    fi
    log "ABORTADO: reencrypt incompleto em: ${FAIL[*]}. O /home fica desmontado. Retomar com:"
    for id in "${FAIL[@]}"; do log "  cryptsetup reencrypt --resume-only --key-file $KEY ${DEVS[$id]}"; done
    log "e depois rodar a parte final à mão (crypttab, abrir, montar, resize max)."
    exit 1
fi

log "crypttab + abrindo pelo systemd-cryptsetup"
cp -a /etc/crypttab /etc/crypttab.bak-2026-11-01-home
for id in 1 2 3; do
    d=${DEVS[$id]}
    LUKSUUID=$(cryptsetup luksUUID "$d")
    opts=luks; [[ $(lsblk -dno ROTA "$d" | xargs) == 0 ]] && opts=luks,discard
    log "home$id: $d → LUKS $LUKSUUID ($opts)"
    grep -q "^home$id " /etc/crypttab || echo "home$id UUID=$LUKSUUID $KEY $opts" >> /etc/crypttab
done
systemctl unmask --runtime home.mount home-.snapshots.mount
systemctl daemon-reload
for id in 1 2 3; do
    systemctl start "systemd-cryptsetup@home$id.service" || { log "ABORTADO: falha ao abrir home$id pelo crypttab"; exit 1; }
done
udevadm settle
btrfs device scan >/dev/null

log "montando e devolvendo os 32M ao btrfs"
systemctl start home.mount || mount "$MNT" || { log "ABORTADO: mount falhou"; exit 1; }
for id in 1 2 3; do btrfs filesystem resize "$id:max" "$MNT"; done
findmnt "$MNT"; btrfs filesystem show "$MNT"; df -h "$MNT"
log "subvolumes depois: $(btrfs subvolume list "$MNT" | wc -l) (antes: $SUBS)"
log "usado depois: $(( $(df -B1 --output=used "$MNT" | tail -1) / 1073741824 )) GiB (antes: $(( USED / 1073741824 )))"
btrfs device stats "$MNT"
religa
log "FIM OK"
