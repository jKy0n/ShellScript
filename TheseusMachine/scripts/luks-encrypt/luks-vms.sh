#!/bin/bash
# Fase 3 da TheseusMachine: tira a partição de swap em claro (nvme1n1p4), troca
# por swapfile no root e cifra o /mnt/VirtualMachines (nvme1n1p3, ext4) no lugar,
# com LUKS2, já crescido até o fim do disco.
#   - swapfile de 16G no subvolume /swap (+C; subvolume aninhado fica fora dos
#     snapshots do snapper);
#   - apaga o p4 e cresce o p3 sobre ele sem crescer o ext4: os últimos 32M ficam
#     livres pro header (--reduce-device-size), sem precisar encolher nada;
#   - para o ollama (modelos em /mnt/VirtualMachines/LLM), cifra com keyfile,
#     crypttab com discard, fstab sem nobarrier, resize2fs online;
#   - progresso no log a cada 60 s pelo /proc/<pid>/io do cryptsetup.
# Log legível pelo jkyon: /var/log/luks-vms.log.
set -uo pipefail
LOG=/var/log/luks-vms.log
touch "$LOG"; chmod 0644 "$LOG"
exec > >(tee -a "$LOG") 2>&1

NAME=vms
MNT=/mnt/VirtualMachines
MOUNTUNIT=mnt-VirtualMachines.mount
FSUUID=269a7908-52df-463d-a560-fd606e738804
SWAPUUID=fecff82b-844d-4ff3-b5bd-0900bb937bb4
DISK=/dev/nvme1n1
KEY=/etc/cryptsetup-keys.d/$NAME.key
LABEL=THESEUS_VMS_LUKS
SWAPFILE=/swap/swapfile

log() { echo "[$(date '+%F %T')] $*"; }

religa() {
    log "religando o ollama"
    systemctl start ollama.service && log "ollama ok"
}
die() { log "ABORTADO: $*"; mountpoint -q "$MNT" && religa; exit 1; }

holders() {
    for p in /proc/[0-9]*; do
        { ls -l "$p/fd" 2>/dev/null; cat "$p/maps" 2>/dev/null; readlink "$p/cwd" "$p/root"; } \
            | grep -qE "(^| )$MNT(/| |\$)" && echo "${p#/proc/} $(cat "$p/comm" 2>/dev/null) uid=$(stat -c %u "$p")"
    done
}

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

# ---------- checagens (nada alterado até aqui) ----------
[[ -x /usr/lib/systemd/system-generators/systemd-cryptsetup-generator ]] \
    || { log "ABORTADO: systemd sem USE=cryptsetup; nada foi alterado"; exit 1; }
DEV=$(blkid -U "$FSUUID") || { log "ABORTADO: ext4 $FSUUID não encontrado"; exit 1; }
SWAPDEV=$(blkid -U "$SWAPUUID") || { log "ABORTADO: swap $SWAPUUID não encontrada"; exit 1; }
[[ $DEV == "${DISK}p3" && $SWAPDEV == "${DISK}p4" ]] \
    || { log "ABORTADO: esperava ${DISK}p3/p4, achei $DEV/$SWAPDEV; nada foi alterado"; exit 1; }
P3END=$(( $(cat /sys/block/${DISK#/dev/}/${DISK#/dev/}p3/start) + $(cat /sys/block/${DISK#/dev/}/${DISK#/dev/}p3/size) ))
[[ $P3END == "$(cat /sys/block/${DISK#/dev/}/${DISK#/dev/}p4/start)" ]] \
    || { log "ABORTADO: p4 não começa logo depois do p3; nada foi alterado"; exit 1; }
[[ $(findmnt -no SOURCE "$MNT" | head -1) == "$DEV" ]] || { log "ABORTADO: $MNT não está montado de $DEV"; exit 1; }
log "início; disco: $DISK ($(lsblk -dno MODEL "$DISK")), ext4 em $DEV, swap em $SWAPDEV"
cp -a /etc/fstab /etc/fstab.bak-2026-10-31

# ---------- 1. swapfile no root, fora com a partição ----------
if ! swapon --show=NAME --noheadings | grep -qx "$SWAPFILE"; then
    log "criando $SWAPFILE (16G, subvolume /swap)"
    [[ -d /swap ]] || btrfs subvolume create /swap || die "subvolume /swap falhou"
    [[ -e $SWAPFILE ]] || btrfs filesystem mkswapfile --size 16g "$SWAPFILE" || die "mkswapfile falhou"
    swapon "$SWAPFILE" || die "swapon do swapfile falhou"
fi
log "swapoff $SWAPDEV ($(awk -v d="$SWAPDEV" '$1==d {print $4}' /proc/swaps) KiB em uso)"
swapoff "$SWAPDEV" || die "swapoff da partição falhou"
sed -i "s|^UUID=$SWAPUUID|# (removida 2026-10-31, virou swapfile) UUID=$SWAPUUID|" /etc/fstab
grep -q "^$SWAPFILE " /etc/fstab || echo "$SWAPFILE none swap defaults 0 0" >> /etc/fstab
swapon --show

# ---------- 2. desmonta o /mnt/VirtualMachines ----------
log "parando o ollama e desmontando $MNT"
systemctl stop ollama.service
systemctl mask --runtime "$MOUNTUNIT"
trap 'systemctl unmask --runtime "$MOUNTUNIT"' EXIT
for i in $(seq 8); do
    h=$(holders); [[ -z $h ]] && break
    log "ainda há processos no $MNT (tentativa $i):"; echo "$h"
    sleep 15
done
[[ -n $h ]] && die "processos não saíram do $MNT; partições intactas"
umount "$MNT" || die "umount falhou; partições intactas"
ns=$(cat /proc/[0-9]*/mountinfo 2>/dev/null | awk -v d="$DEV" '$0 ~ " "d" " {print $5}' | sort | uniq -c)
if [[ -n $ns ]]; then
    echo "$ns"
    systemctl unmask --runtime "$MOUNTUNIT"; mount "$MNT"
    die "$DEV ainda montado em outra namespace; partições intactas"
fi

# ---------- 3. apaga o p4 e cresce o p3 até o fim do disco ----------
log "apagando o p4 (swap) e crescendo o p3"
sfdisk --dump "$DISK" > /root/nvme1n1-gpt-2026-10-31.sfdisk
wipefs -a "$SWAPDEV"
# o Ventoy (p1) segue montado: sem --no-reread o sfdisk recusa disco em uso, e
# o kernel é avisado partição por partição pelo partx
sfdisk --no-reread --delete "$DISK" 4 || die "sfdisk --delete falhou (dump em /root/nvme1n1-gpt-2026-10-31.sfdisk)"
echo ', +' | sfdisk --no-reread -N 3 "$DISK" || die "sfdisk -N 3 falhou (dump em /root/nvme1n1-gpt-2026-10-31.sfdisk)"
partx -d --nr 4 "$DISK"; partx -u --nr 3 "$DISK"; udevadm settle
lsblk -o NAME,SIZE,FSTYPE,LABEL "$DISK"
SIZE=$(blockdev --getsize64 "$DEV")
(( SIZE > 400000000000 )) || die "o kernel ainda vê o p3 com $SIZE bytes (esperado ~436 GB)"

# ---------- 4. cifra ----------
log "keyfile $KEY"
install -d -m 0700 /etc/cryptsetup-keys.d
[[ -e $KEY ]] || (umask 077; dd if=/dev/urandom of="$KEY" bs=512 count=1 status=none)
chmod 0400 "$KEY"

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
    systemctl unmask --runtime "$MOUNTUNIT"; mount "$MNT"
    die "reencrypt não começou (rc=$RC); ext4 remontado sem cifra"
fi
LUKSUUID=$(cryptsetup luksUUID "$DEV")
log "LUKS $LUKSUUID"

# ---------- 5. crypttab, fstab, monta, cresce ----------
log "crypttab + fstab (sem nobarrier)"
grep -q "^$NAME " /etc/crypttab 2>/dev/null \
    || echo "$NAME UUID=$LUKSUUID $KEY luks,discard" >> /etc/crypttab
sed -i "s|^# /dev/nvme2n1p3 LABEL=VirtualMachines|# /dev/nvme1n1p3 → LUKS2 $LABEL → /dev/mapper/$NAME, LABEL=VirtualMachines|" /etc/fstab
sed -i "/^UUID=$FSUUID/ s|,nobarrier||" /etc/fstab
grep -nE "VirtualMachines|swap" /etc/fstab
systemctl unmask --runtime "$MOUNTUNIT"
systemctl daemon-reload
systemctl start "systemd-cryptsetup@$NAME.service" || { log "ABORTADO: falha ao abrir pelo crypttab"; exit 1; }
udevadm settle
systemctl start "$MOUNTUNIT" || mount "$MNT" || { log "ABORTADO: mount falhou"; exit 1; }
log "resize2fs online até o fim do LUKS"
resize2fs "/dev/mapper/$NAME"
findmnt "$MNT"; lsblk "$DISK"; df -h "$MNT"
religa
log "FIM OK"
