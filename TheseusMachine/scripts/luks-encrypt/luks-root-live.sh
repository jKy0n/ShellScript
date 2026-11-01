#!/bin/bash
# Fase 4a da TheseusMachine: cifra o root (btrfs "gentoo") no lugar, com LUKS2,
# a partir de um live (Arch ISO do Ventoy). Tudo o resto já foi preparado no
# sistema em 2026-10-31: btrfs encolhido 32M, UUID do LUKS gerado (arquivo uuid
# ao lado), initramfs com systemd-cryptsetup/TPM2/br-abnt2, grub.cfg.luks pronto.
#
# Uso no live:
#   mount /dev/disk/by-label/boot /mnt
#   bash /mnt/luks-root/luks-root-live.sh
# Se parar no meio (queda de luz etc.), rodar de novo: retoma com --resume-only.
set -uo pipefail
DIR=$(dirname "$(readlink -f "$0")")
BOOT=$(dirname "$DIR")
LOG=$DIR/luks-root.log
FSUUID=ca1a25e0-915b-415c-8934-0ca8f7d35f99
LUKSUUID=$(cat "$DIR/uuid")
LABEL=THESEUS_ROOT_LUKS

log() { echo "[$(date '+%F %T')] $*" | tee -a "$LOG"; }
die() { log "ABORTADO: $*"; exit 1; }

log "início (live: $(uname -r), $(cryptsetup --version))"
[[ -f $BOOT/grub/grub.cfg.luks && -f $BOOT/grub/grub.cfg.pre-luks ]] \
    || die "$BOOT não parece o /boot da TheseusMachine (faltam grub.cfg.luks/pre-luks)"
loadkeys br-abnt2 && log "teclado: br-abnt2 (o mesmo do initramfs)" \
    || die "loadkeys br-abnt2 falhou: a senha digitada aqui não bateria com a do boot"

if DEV=$(blkid -U "$FSUUID" 2>/dev/null) && [[ $(blkid -s TYPE -o value "$DEV") == btrfs ]]; then
    MODE=novo
elif [[ -e /dev/disk/by-uuid/$LUKSUUID ]]; then
    DEV=$(readlink -f "/dev/disk/by-uuid/$LUKSUUID")
    if cryptsetup luksDump "$DEV" | grep -qi 'online-reencrypt'; then MODE=retomar; else MODE=pronto; fi
else
    die "não achei nem o btrfs $FSUUID nem o LUKS $LUKSUUID"
fi
log "root: $DEV ($(lsblk -dno SIZE "$DEV")), modo: $MODE"
findmnt -S "$DEV" >/dev/null && die "$DEV está montado"

case $MODE in
novo)
    FREE=$(( $(blockdev --getsize64 "$DEV") - $(btrfs inspect-internal dump-super "$DEV" | awk '/^dev_item.total_bytes/ {print $2}') ))
    log "espaço livre no fim da partição: $FREE bytes (precisa de 33554432)"
    (( FREE >= 33554432 )) || die "o btrfs não foi encolhido 32M; nada foi alterado"
    echo
    echo "Vai cifrar $DEV (root da TheseusMachine) com LUKS2, UUID $LUKSUUID."
    echo "A senha é a senha longa padronizada (a mesma do Viamar), pedida 2 vezes."
    read -rp "Digite SIM pra começar: " ok
    [[ $ok == SIM ]] || die "cancelado pelo usuário; nada foi alterado"
    log "cryptsetup reencrypt --encrypt"
    cryptsetup reencrypt --encrypt --type luks2 --uuid "$LUKSUUID" --label "$LABEL" \
        --reduce-device-size 32M --pbkdf argon2id --verify-passphrase \
        --progress-frequency 10 "$DEV" \
        || die "reencrypt parou (rc=$?). Rodar o script de novo pra retomar"
    ;;
retomar)
    log "reencrypt pela metade: retomando (pede a senha)"
    cryptsetup reencrypt --resume-only --progress-frequency 10 "$DEV" \
        || die "retomada parou (rc=$?). Rodar o script de novo"
    ;;
pronto)
    log "já está cifrado e sem reencrypt pendente"
    ;;
esac

[[ $(cryptsetup luksUUID "$DEV") == "$LUKSUUID" ]] || die "UUID do LUKS diferente do esperado"
cryptsetup luksDump "$DEV" | grep -qi 'online-reencrypt' && die "ainda há reencrypt pendente; rodar de novo"

log "conferindo: abrindo o LUKS (pede a senha mais uma vez)"
cryptsetup open "$DEV" cryptroot || die "não abriu com a senha digitada"
B=$(blkid -s UUID -o value /dev/mapper/cryptroot)
cryptsetup close cryptroot
[[ $B == "$FSUUID" ]] || die "dentro do LUKS não está o btrfs $FSUUID (achei: $B)"
log "dentro do LUKS: btrfs $B (ok)"

cp "$BOOT/grub/grub.cfg.luks" "$BOOT/grub/grub.cfg" && sync
grep -q "rd.luks.uuid=$LUKSUUID" "$BOOT/grub/grub.cfg" || die "falha ao trocar o grub.cfg"
log "grub.cfg trocado pelo grub.cfg.luks (o antigo está em grub.cfg.pre-luks)"
log "FIM OK. Agora: umount /mnt && reboot (o boot vai pedir a senha longa)"
