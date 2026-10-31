#!/bin/bash
# Cifra o /mnt/backup (sdd1, btrfs) da TheseusMachine no lugar, com LUKS2.
# Mesmo método do /mnt/fast e do /home do Viamar-PC (2026-10-29/30), adaptado:
#   - não espera logout: a sessão gráfica não usa o /mnt/backup;
#   - para o borg-ui (bind /mnt/backup:/backups segura o disco na namespace do
#     container) e os timers do snapper, e mascara o mnt-backup.mount em runtime;
#   - acha quem segura o disco varrendo o /proc (fuser -m não vê subvolume);
#   - cifra com keyfile (ninguém digita senha), crypttab, monta, religa tudo;
#   - progresso no log a cada 60 s pelo /proc/<pid>/io do cryptsetup (o
#     --progress-frequency só escreve em terminal).
# Log legível pelo jkyon: /var/log/luks-backup.log.
set -uo pipefail
LOG=/var/log/luks-backup.log
touch "$LOG"; chmod 0644 "$LOG"
exec > >(tee -a "$LOG") 2>&1

NAME=backup
MNT=/mnt/backup
FSUUID=13fab9bd-bc62-4ecc-833c-9a51ff438159
KEY=/etc/cryptsetup-keys.d/$NAME.key
LABEL=THESEUS_BACKUP_LUKS

log() { echo "[$(date '+%F %T')] $*"; }

religa() {
    log "religando serviços"
    systemctl start snapper-timeline.timer snapper-cleanup.timer
    systemctl start borg-ui.service && log "borg-ui ok"
}
die() { log "ABORTADO: $*"; mountpoint -q "$MNT" && religa; exit 1; }

holders() {
    for p in /proc/[0-9]*; do
        { ls -l "$p/fd" 2>/dev/null; cat "$p/maps" 2>/dev/null; readlink "$p/cwd" "$p/root"; } \
            | grep -qE "(^| )$MNT(/| |\$)" && echo "${p#/proc/} $(cat "$p/comm" 2>/dev/null) uid=$(stat -c %u "$p")"
    done
}

# bytes lidos pelo cryptsetup / tamanho do device, a cada 60 s
progress() {
    local pid=$1 size=$2 prev=0 now rd
    while kill -0 "$pid" 2>/dev/null; do
        sleep 60
        rd=$(awk '/^read_bytes/ {print $2}' "/proc/$pid/io" 2>/dev/null) || break
        [[ -z $rd ]] && break
        now=$(( (rd - prev) / 60 / 1048576 )); prev=$rd
        log "progresso: $(( rd * 100 / size ))% ($(( rd / 1073741824 ))/$(( size / 1073741824 )) GiB, ${now} MiB/s)"
    done
}

[[ -x /usr/lib/systemd/system-generators/systemd-cryptsetup-generator ]] \
    || { log "ABORTADO: systemd sem USE=cryptsetup (crypttab não seria lido); nada foi alterado"; exit 1; }
DEV=$(blkid -U "$FSUUID") || { log "ABORTADO: btrfs $FSUUID não encontrado"; exit 1; }
[[ $(findmnt -no SOURCE "$MNT" | head -1) == "$DEV" ]] || { log "ABORTADO: $MNT não está montado de $DEV"; exit 1; }
SIZE=$(blockdev --getsize64 "$DEV")
log "início; disco: $DEV ($(lsblk -dno MODEL "${DEV%1}") $(lsblk -dno SIZE "$DEV"))"
SUBS=$(btrfs subvolume list "$MNT" | wc -l); log "subvolumes antes: $SUBS"

log "parando borg-ui e snapper"
systemctl stop borg-ui.service
systemctl mask --runtime mnt-backup.mount
trap 'systemctl unmask --runtime mnt-backup.mount' EXIT
systemctl stop snapper-timeline.timer snapper-cleanup.timer snapper-timeline.service snapper-cleanup.service

for i in $(seq 8); do
    h=$(holders); [[ -z $h ]] && break
    log "ainda há processos no $MNT (tentativa $i):"; echo "$h"
    sleep 15
done
[[ -n $h ]] && die "processos não saíram do $MNT; nada foi alterado"

log "keyfile $KEY"
install -d -m 0700 /etc/cryptsetup-keys.d
[[ -e $KEY ]] || (umask 077; dd if=/dev/urandom of="$KEY" bs=512 count=1 status=none)
chmod 0400 "$KEY"

log "encolhendo o btrfs em 32M e desmontando"
btrfs filesystem resize -32M "$MNT" || die "resize falhou; nada foi alterado"
sync
for i in $(seq 10); do
    mountpoint -q "$MNT" || break
    umount "$MNT" && continue
    log "umount ocupado (tentativa $i):"; holders
    sleep 3
done
mountpoint -q "$MNT" && { btrfs filesystem resize max "$MNT"; die "umount falhou; resize revertido"; }
# container ou outro serviço pode ter montado o disco na namespace dele
ns=$(cat /proc/[0-9]*/mountinfo 2>/dev/null | awk -v d="$DEV" '$0 ~ " "d" " {print $5}' | sort | uniq -c)
if [[ -n $ns ]]; then
    echo "$ns"
    mount "$MNT" && btrfs filesystem resize max "$MNT"
    die "$DEV ainda montado em outra namespace; remontado sem cifra"
fi

log "cryptsetup reencrypt --encrypt ($(( SIZE / 1073741824 )) GiB)"
cryptsetup reencrypt --encrypt --type luks2 --reduce-device-size 32M \
    --label "$LABEL" --key-file "$KEY" --batch-mode "$DEV" &
CPID=$!
progress "$CPID" "$SIZE" &
wait "$CPID"; RC=$?
if (( RC != 0 )); then
    cryptsetup isLuks "$DEV" && {
        log "ABORTADO: reencrypt interrompido no meio (rc=$RC). Retomar com:"
        log "  cryptsetup reencrypt --resume-only --key-file $KEY $DEV"
        exit 1; }
    mount "$MNT" && btrfs filesystem resize max "$MNT"
    die "reencrypt não começou (rc=$RC); disco remontado sem cifra"
fi
LUKSUUID=$(cryptsetup luksUUID "$DEV")
log "LUKS $LUKSUUID"

log "crypttab + abrindo pelo systemd-cryptsetup"
grep -q "^$NAME " /etc/crypttab 2>/dev/null \
    || echo "$NAME UUID=$LUKSUUID $KEY luks" >> /etc/crypttab
systemctl unmask --runtime mnt-backup.mount
systemctl daemon-reload
systemctl start "systemd-cryptsetup@$NAME.service" || { log "ABORTADO: falha ao abrir pelo crypttab"; exit 1; }
udevadm settle

log "montando e devolvendo os 32M ao btrfs"
systemctl start mnt-backup.mount || mount "$MNT" || { log "ABORTADO: mount falhou"; exit 1; }
btrfs filesystem resize max "$MNT"
findmnt "$MNT"; lsblk "${DEV%1}"; df -h "$MNT"
log "subvolumes depois: $(btrfs subvolume list "$MNT" | wc -l) (antes: $SUBS)"
religa
log "FIM OK"
