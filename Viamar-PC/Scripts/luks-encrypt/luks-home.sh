#!/bin/bash
# Cifra o /home (sda, btrfs no disco inteiro) no lugar, com LUKS2.
# Mesmo método do /mnt/fast (2026-10-29), adaptado:
#   - espera o jkyon sair da sessão gráfica (até DEADLINE), sem nada alterar;
#   - para borg-ui, bees, snapper e o usuário jkyon inteiro (inclui o Claude
#     Code que roda de dentro do /home: quem acompanha é a TheseusMachine);
#   - acha quem segura o disco varrendo o /proc (fuser -m não vê subvolume);
#   - cifra com keyfile (ninguém digita senha), crypttab, monta, religa tudo.
# Log legível pelo jkyon: /var/log/luks-home.log (progresso a cada 60 s).
set -uo pipefail
LOG=/var/log/luks-home.log
touch "$LOG"; chmod 0644 "$LOG"
exec > >(tee -a "$LOG") 2>&1

NAME=home
MNT=/home
FSUUID=bb592b19-cf33-4e5d-9cd5-ae99a750a142
KEY=/etc/cryptsetup-keys.d/$NAME.key
BEES=beesd@$FSUUID.service
DEADLINE=${DEADLINE:-19:30}

log() { echo "[$(date '+%F %T')] $*"; }

religa() {
    log "religando serviços"
    systemctl start "$BEES" snapper-timeline.timer snapper-cleanup.timer
    docker start borg-ui >/dev/null && log "borg-ui ok"
}
die() { log "ABORTADO: $*"; mountpoint -q "$MNT" && religa; exit 1; }

holders() {
    for p in /proc/[0-9]*; do
        { ls -l "$p/fd" 2>/dev/null; cat "$p/maps" 2>/dev/null; readlink "$p/cwd" "$p/root"; } \
            | grep -qE "(^| )$MNT(/| |\$)" && echo "${p#/proc/} $(cat "$p/comm" 2>/dev/null) uid=$(stat -c %u "$p")"
    done
}

graphical() { loginctl list-sessions --no-legend | awk '$3=="jkyon" && $4=="seat0"' | grep -q .; }

log "início; esperando o jkyon sair da sessão gráfica (até $DEADLINE)"
until ! graphical; do
    [[ $(date +%H:%M) > $DEADLINE ]] && { log "ABORTADO: sessão ainda aberta às $DEADLINE; nada foi alterado"; exit 1; }
    sleep 15
done

DEV=$(blkid -U "$FSUUID") || { log "ABORTADO: btrfs $FSUUID não encontrado"; exit 1; }
[[ $(findmnt -no SOURCE "$MNT") == "$DEV" ]] || { log "ABORTADO: $MNT não está montado de $DEV"; exit 1; }
log "sessão fechada; disco: $DEV ($(lsblk -dno MODEL,SIZE "$DEV"))"
SUBS=$(btrfs subvolume list "$MNT" | wc -l); log "subvolumes antes: $SUBS"

log "parando borg-ui, bees, snapper e o usuário jkyon"
docker stop borg-ui >/dev/null
systemctl stop snapper-timeline.timer snapper-cleanup.timer snapper-timeline.service snapper-cleanup.service "$BEES"
loginctl terminate-user jkyon
systemctl stop user@1000.service
umount /mnt/theseusmachine /mnt/crisnote 2>/dev/null

for i in $(seq 20); do
    h=$(holders); [[ -z $h ]] && break
    log "ainda há processos no $MNT (tentativa $i):"; echo "$h"
    loginctl terminate-user jkyon 2>/dev/null
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
    umount "$MNT" && break
    log "umount ocupado (tentativa $i):"; holders
    sleep 3
done
mountpoint -q "$MNT" && { btrfs filesystem resize max "$MNT"; die "umount falhou; resize revertido"; }
# bees e borg-ui montam o disco nas namespaces deles: nenhuma pode sobrar
ns=$(cat /proc/[0-9]*/mountinfo 2>/dev/null | awk -v d="$DEV" '$0 ~ " "d" " {print $5}' | sort | uniq -c)
if [[ -n $ns ]]; then
    echo "$ns"
    mount "$MNT" && btrfs filesystem resize max "$MNT"
    die "$DEV ainda montado em outra namespace; remontado sem cifra"
fi

log "cryptsetup reencrypt --encrypt (progresso a cada 60 s)"
if ! cryptsetup reencrypt --encrypt --type luks2 --reduce-device-size 32M \
        --label VIAMAR_HOME_LUKS --key-file "$KEY" --batch-mode \
        --progress-frequency 60 "$DEV"; then
    cryptsetup isLuks "$DEV" && {
        log "ABORTADO: reencrypt interrompido no meio. Retomar com:"
        log "  cryptsetup reencrypt --resume-only --key-file $KEY $DEV"
        exit 1; }
    mount "$MNT" && btrfs filesystem resize max "$MNT"
    die "reencrypt não começou; disco remontado sem cifra"
fi
echo
LUKSUUID=$(cryptsetup luksUUID "$DEV")
log "LUKS $LUKSUUID"

log "crypttab + abrindo pelo systemd-cryptsetup"
grep -q "^$NAME " /etc/crypttab 2>/dev/null \
    || echo "$NAME UUID=$LUKSUUID $KEY luks" >> /etc/crypttab
systemctl daemon-reload
systemctl start "systemd-cryptsetup@$NAME.service" || { log "ABORTADO: falha ao abrir pelo crypttab"; exit 1; }
udevadm settle

log "montando e devolvendo os 32M ao btrfs"
mount "$MNT" || { log "ABORTADO: mount falhou"; exit 1; }
btrfs filesystem resize max "$MNT"
findmnt "$MNT"; lsblk "$DEV"; df -h "$MNT"
log "subvolumes depois: $(btrfs subvolume list "$MNT" | wc -l) (antes: $SUBS)"
religa
log "FIM OK"
