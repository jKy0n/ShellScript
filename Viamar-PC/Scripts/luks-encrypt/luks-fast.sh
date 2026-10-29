#!/bin/bash
# Cifra o /mnt/fast (btrfs no disco inteiro) no lugar, com LUKS2.
# Roda como unit transitória de root: espera o jkyon sair da sessão gráfica,
# para o user manager, faz a última passada do backup e cifra com keyfile.
# Log: /root/luks-fast.log (e journal da unit).
set -uo pipefail
exec > >(tee -a /root/luks-fast.log) 2>&1

NAME=fast
MNT=/mnt/fast
FSUUID=7808abff-c725-45ab-a917-1729c4c91090
KEY=/etc/cryptsetup-keys.d/$NAME.key
BKP=/mnt/backup/fast-pre-luks-2026-10-29

log() { echo "[$(date '+%F %T')] $*"; }
die() { log "ABORTADO: $*"; exit 1; }

log "início (sessão gráfica já fechada; syncthing parado à mão)"
# fuser -m não enxerga subvolume btrfs (st_dev anônimo próprio): varre o /proc
holders() {
    for p in /proc/[0-9]*; do
        { ls -l "$p/fd" 2>/dev/null; cat "$p/maps" 2>/dev/null; readlink "$p/cwd" "$p/root"; } \
            | grep -q "$MNT" && echo "${p#/proc/} $(cat "$p/comm" 2>/dev/null)"
    done
}
h=$(holders)
[[ -n $h ]] && { echo "$h"; die "ainda há processos no $MNT; nada foi alterado"; }

DEV=$(blkid -U "$FSUUID") || die "btrfs $FSUUID não encontrado"
[[ $(findmnt -no SOURCE "$MNT") == "$DEV" ]] || die "$MNT não está montado de $DEV"
log "disco: $DEV ($(lsblk -dno MODEL,SIZE "$DEV"))"

log "última passada do backup (rsync --delete)"
rsync -aAXHS --numeric-ids --delete "$MNT"/ "$BKP"/ || die "rsync falhou; nada foi alterado"
log "backup: $(find "$BKP" | wc -l) entradas, origem: $(find "$MNT" | wc -l)"

log "keyfile $KEY"
install -d -m 0700 /etc/cryptsetup-keys.d
[[ -e $KEY ]] || (umask 077; dd if=/dev/urandom of="$KEY" bs=512 count=1 status=none)
chmod 0400 "$KEY"

log "encolhendo o btrfs em 32M e desmontando"
btrfs filesystem resize -32M "$MNT" || die "resize falhou; nada foi alterado"
sync
for i in $(seq 10); do
    umount "$MNT" && break
    log "umount ocupado (tentativa $i):"; holders
    sleep 2
done
mountpoint -q "$MNT" && { btrfs filesystem resize max "$MNT"; die "umount falhou; resize revertido"; }

log "cryptsetup reencrypt --encrypt"
if ! cryptsetup reencrypt --encrypt --type luks2 --reduce-device-size 32M \
        --label VIAMAR_FAST_LUKS --key-file "$KEY" --batch-mode "$DEV"; then
    cryptsetup isLuks "$DEV" \
        && die "reencrypt interrompido no meio: retomar com 'cryptsetup reencrypt --resume-only --key-file $KEY $DEV'"
    mount "$MNT" && btrfs filesystem resize max "$MNT"
    die "reencrypt não começou; disco remontado sem cifra"
fi
LUKSUUID=$(cryptsetup luksUUID "$DEV")
log "LUKS $LUKSUUID"

log "crypttab + abrindo pelo systemd-cryptsetup"
grep -q "^$NAME " /etc/crypttab 2>/dev/null \
    || echo "$NAME UUID=$LUKSUUID $KEY luks,discard" >> /etc/crypttab
systemctl daemon-reload
systemctl start "systemd-cryptsetup@$NAME.service" || die "falha ao abrir pelo crypttab"
udevadm settle

log "montando e devolvendo os 32M ao btrfs"
mount "$MNT" || die "mount falhou"
btrfs filesystem resize max "$MNT"
findmnt "$MNT"; lsblk "$DEV"; df -h "$MNT"
log "contagem depois: $(find "$MNT" | wc -l)"
log "FIM OK"
