#!/bin/bash
# Fase 2 da TheseusMachine: recria o quickStorage (nvme0n1p4, btrfs) como /mnt/fast
# em LUKS2, com tudo sob um mount só: /mnt/fast/{cache,Desktop,Downloads,
# loki-data,prometheus-data}. Não é reencrypt no lugar: copia pro /mnt/backup,
# formata, copia de volta (70G em NVMe; o layout muda de qualquer jeito).
#   - espera o jkyon sair da sessão gráfica (o ~/.cache, ~/.builds, baloo e
#     atuin moram aqui), para borg-ui, loki/prometheus e o usuário inteiro;
#   - staging num subvolume do /mnt/backup (fora dos snapshots do snapper);
#   - luksFormat com keyfile, crypttab com discard, btrfs novo (label fast),
#     +C no subvolume cache antes de qualquer arquivo;
#   - troca as referências aos caminhos antigos (symlinks do home, compose do
#     loki-stack e do borg-ui, make.conf, sccache, atuin, alias/zellij), com .bak;
#   - corrige o cache do borg-ui (o borg roda como root e o volume estava em
#     /home/borg/.cache/borg: todo container novo refazia o cache do zero).
# Log legível pelo jkyon: /var/log/luks-fast.log.
set -uo pipefail
LOG=/var/log/luks-fast.log
touch "$LOG"; chmod 0644 "$LOG"
exec > >(tee -a "$LOG") 2>&1

NAME=fast
MNT=/mnt/fast
OLDUUID=a9157442-4798-438c-9a60-5aa42855532f
KEY=/etc/cryptsetup-keys.d/$NAME.key
LABEL=THESEUS_FAST_LUKS
STAGE=/mnt/backup/fast-pre-luks-2026-10-31
OLDTOP=/run/fast-old
SUBS=(cache Desktop Downloads loki-data prometheus-data)
OLDMNTS=(/mnt/cache /mnt/Desktop /mnt/Downloads /mnt/loki-data /mnt/prometheus-data /mnt/quickStorage-root)
OPTS=rw,relatime,compress=zstd:3,ssd,discard=async,space_cache=v2
DEADLINE=${DEADLINE:-23:30}
U=jkyon
H=/home/$U
LOKI=$H/Apps/docker/loki-stack/docker-compose.yml
BORGUI=$H/Apps/docker/borg-ui-docker/docker-compose.yml
BAK=.bak-2026-10-31

log() { echo "[$(date '+%F %T')] $*"; }
warn() { log "AVISO: $*"; }

units() {
    local m
    for m in "${OLDMNTS[@]}"; do systemd-escape -p --suffix=mount "$m"; done
    systemd-escape -p --suffix=automount /mnt/quickStorage-root
}

religa_antigo() {
    log "religando no layout antigo"
    systemctl unmask --runtime $(units) 2>/dev/null
    systemctl daemon-reload
    for m in "${OLDMNTS[@]:0:5}"; do systemctl start "$(systemd-escape -p --suffix=mount "$m")"; done
    docker compose -f "$LOKI" start loki prometheus
    systemctl start borg-ui.service
}
die() { log "ABORTADO: $*"; religa_antigo; exit 1; }

holders() {
    for p in /proc/[0-9]*; do
        { ls -l "$p/fd" 2>/dev/null; cat "$p/maps" 2>/dev/null; readlink "$p/cwd" "$p/root"; } \
            | grep -qE "(^| )/mnt/(cache|Desktop|Downloads|loki-data|prometheus-data|quickStorage-root)(/| |\$)" \
            && echo "${p#/proc/} $(cat "$p/comm" 2>/dev/null) uid=$(stat -c %u "$p")"
    done
}

graphical() {
    for s in $(loginctl list-sessions --no-legend | awk -v u=$U '$3==u && $4=="seat0" {print $1}'); do
        [[ $(loginctl show-session "$s" -p State --value) != closing ]] && return 0
    done
    return 1
}

count() { find "$1" -xdev 2>/dev/null | wc -l; }

# ---------- checagens (nada alterado até aqui) ----------
[[ -x /usr/lib/systemd/system-generators/systemd-cryptsetup-generator ]] \
    || { log "ABORTADO: systemd sem USE=cryptsetup; nada foi alterado"; exit 1; }
DEV=$(blkid -U "$OLDUUID") || { log "ABORTADO: btrfs $OLDUUID não encontrado"; exit 1; }
[[ $DEV == /dev/nvme0n1p4 ]] || { log "ABORTADO: esperava /dev/nvme0n1p4, achei $DEV; nada foi alterado"; exit 1; }
[[ $(findmnt -no SOURCE /mnt/backup) == /dev/mapper/backup ]] || { log "ABORTADO: /mnt/backup não está montado do LUKS"; exit 1; }
USED=$(btrfs filesystem usage -b /mnt/cache 2>/dev/null | awk '/Used:/ {print $2; exit}')
FREE=$(df -B1 --output=avail /mnt/backup | tail -1)
(( FREE > USED * 3 / 2 )) || { log "ABORTADO: /mnt/backup com $FREE livres pra $USED usados; nada foi alterado"; exit 1; }
[[ -e $STAGE ]] && { log "ABORTADO: $STAGE já existe (rodada anterior?); nada foi alterado"; exit 1; }
log "início; $DEV ($(lsblk -dno MODEL /dev/nvme0n1)), $(( USED / 1073741824 )) GiB usados"

log "esperando o $U sair da sessão gráfica (até $DEADLINE)"
until ! graphical; do
    [[ $(date +%H:%M) > $DEADLINE ]] && { log "ABORTADO: sessão ainda aberta às $DEADLINE; nada foi alterado"; exit 1; }
    sleep 15
done
log "sessão fechada"

# ---------- cache do borg-ui (antes de parar o container; só com FIX_BORG_CACHE=1) ----------
if [[ ${FIX_BORG_CACHE:-0} == 1 ]] && grep -q 'borg_cache:/home/borg/.cache/borg' "$BORGUI"; then
    log "borg-ui: copiando o cache do borg (/root/.cache/borg) pro volume borg_cache"
    if docker exec borg-web-ui sh -c 'rm -rf /home/borg/.cache/borg/* && cp -a /root/.cache/borg/. /home/borg/.cache/borg/'; then
        runuser -u $U -- cp -p "$BORGUI" "$BORGUI$BAK"
        runuser -u $U -- sed -i 's|borg_cache:/home/borg/.cache/borg|borg_cache:/root/.cache/borg|' "$BORGUI"
    else
        warn "cópia do cache do borg falhou; compose do borg-ui não alterado nesse ponto"
    fi
fi

# ---------- para tudo que usa o quickStorage ----------
log "parando borg-ui, loki/prometheus e o usuário $U"
systemctl stop borg-ui.service
docker compose -f "$LOKI" stop loki prometheus
systemctl mask --runtime $(units)
loginctl terminate-user $U
systemctl stop user@1000.service
for i in $(seq 12); do
    h=$(holders); [[ -z $h ]] && break
    log "ainda há processos nos caminhos antigos (tentativa $i):"; echo "$h"
    loginctl terminate-user $U 2>/dev/null
    sleep 10
done
[[ -n $h ]] && die "processos não saíram; nada foi alterado"

systemctl stop "$(systemd-escape -p --suffix=automount /mnt/quickStorage-root)"
for m in "${OLDMNTS[@]}"; do
    for i in 1 2 3; do mountpoint -q "$m" || break; umount "$m" || sleep 2; done
    mountpoint -q "$m" && die "umount de $m falhou; nada foi alterado"
done

# ---------- cópia pro staging ----------
log "staging: $STAGE"
mkdir -p "$OLDTOP"
mount -o ro,subvolid=5 "$DEV" "$OLDTOP" || die "mount ro do btrfs antigo falhou"
btrfs subvolume create "$STAGE" || { umount "$OLDTOP"; die "subvolume de staging falhou"; }
rsync -aAXHS --numeric-ids --info=stats1 --exclude=/.beeshome "$OLDTOP"/ "$STAGE"/ \
    || { umount "$OLDTOP"; die "rsync pro staging falhou; nada foi alterado"; }
for s in "${SUBS[@]}" .Trash; do
    [[ -e $OLDTOP/$s ]] || continue
    a=$(count "$OLDTOP/$s"); b=$(count "$STAGE/$s")
    log "  $s: origem $a, staging $b"
    [[ $a == "$b" ]] || { umount "$OLDTOP"; die "contagem diferente em $s; nada foi alterado"; }
done
umount "$OLDTOP"
ns=$(cat /proc/[0-9]*/mountinfo 2>/dev/null | awk -v d="$DEV" '$0 ~ " "d" " {print $5}' | sort | uniq -c)
[[ -n $ns ]] && { echo "$ns"; die "$DEV ainda montado em alguma namespace; nada foi alterado"; }

# ---------- ponto sem volta: formata ----------
log "keyfile $KEY"
install -d -m 0700 /etc/cryptsetup-keys.d
[[ -e $KEY ]] || (umask 077; dd if=/dev/urandom of="$KEY" bs=512 count=1 status=none)
chmod 0400 "$KEY"

log "PONTO SEM VOLTA: luksFormat em $DEV (os dados estão em $STAGE)"
wipefs -a "$DEV"
cryptsetup luksFormat --type luks2 --label "$LABEL" --key-file "$KEY" --batch-mode "$DEV" \
    || { log "ABORTADO: luksFormat falhou; dados em $STAGE"; exit 1; }
LUKSUUID=$(cryptsetup luksUUID "$DEV")
log "LUKS $LUKSUUID"
grep -q "^$NAME " /etc/crypttab || echo "$NAME UUID=$LUKSUUID $KEY luks,discard" >> /etc/crypttab
systemctl daemon-reload
systemctl start "systemd-cryptsetup@$NAME.service" || { log "ABORTADO: falha ao abrir pelo crypttab; dados em $STAGE"; exit 1; }
udevadm settle

mkfs.btrfs -f -L fast "/dev/mapper/$NAME" || { log "ABORTADO: mkfs falhou; dados em $STAGE"; exit 1; }
FSUUID=$(blkid -s UUID -o value "/dev/mapper/$NAME")
log "btrfs $FSUUID"
mkdir -p "$MNT"
mount -o "$OPTS" "/dev/mapper/$NAME" "$MNT" || { log "ABORTADO: mount do btrfs novo falhou; dados em $STAGE"; exit 1; }
for s in "${SUBS[@]}"; do btrfs subvolume create "$MNT/$s"; done
chattr +C "$MNT/cache"
lsattr -d "$MNT/cache"

# ---------- cópia de volta ----------
log "copiando de volta"
for s in "${SUBS[@]}"; do
    rsync -aAXHS --numeric-ids "$STAGE/$s"/ "$MNT/$s"/ || { log "ABORTADO: rsync de $s falhou; dados em $STAGE"; exit 1; }
    a=$(count "$STAGE/$s"); b=$(count "$MNT/$s")
    log "  $s: staging $a, novo $b"
    [[ $a == "$b" ]] || { log "ABORTADO: contagem diferente em $s; dados em $STAGE"; exit 1; }
done
[[ -e $STAGE/.Trash ]] && rsync -aAXHS --numeric-ids "$STAGE/.Trash" "$MNT"/

# ---------- fstab ----------
log "fstab"
cp -a /etc/fstab "/etc/fstab$BAK-fast"
sed -i "s|^UUID=$OLDUUID|# (quickStorage antigo, virou /mnt/fast em 2026-10-31) UUID=$OLDUUID|" /etc/fstab
grep -q "^UUID=$FSUUID " /etc/fstab || printf '#\n# /dev/nvme0n1p4 → LUKS2 %s → /dev/mapper/%s, LABEL=fast\nUUID=%s     %s    btrfs  %s,subvolid=5  0 0\n' \
    "$LABEL" "$NAME" "$FSUUID" "$MNT" "$OPTS" >> /etc/fstab
umount "$MNT"
systemctl unmask --runtime $(units)
systemctl daemon-reload
systemctl start mnt-fast.mount || { log "ABORTADO: mnt-fast.mount falhou (fstab?); dados em $STAGE"; exit 1; }
for m in "${OLDMNTS[@]}"; do mountpoint -q "$m" || rmdir "$m" 2>/dev/null; done

# ---------- referências aos caminhos antigos ----------
log "atualizando referências"
for f in /etc/portage/make.conf /etc/portage/env/sccache-rust.conf; do
    cp -a "$f" "$f$BAK" && sed -i 's|/mnt/cache/|/mnt/fast/cache/|g' "$f" || warn "falhou em $f"
done
userfix() {   # arquivo do jkyon: backup + sed, mantendo o dono
    local f=$1; shift
    runuser -u $U -- cp -p "$f" "$f$BAK" && runuser -u $U -- sed -i "$@" "$f" || warn "falhou em $f"
}
userfix "$LOKI" -e 's|/mnt/loki-data:|/mnt/fast/loki-data:|' -e 's|/mnt/prometheus-data:|/mnt/fast/prometheus-data:|'
[[ -e $BORGUI$BAK ]] || runuser -u $U -- cp -p "$BORGUI" "$BORGUI$BAK"
runuser -u $U -- sed -i -e 's|/mnt/Downloads:|/mnt/fast/Downloads:|' -e 's|/mnt/Desktop:|/mnt/fast/Desktop:|' "$BORGUI" || warn "falhou em $BORGUI"
runuser -u $U -- sed -i 's|/mnt/cache/atuin/|/mnt/fast/cache/atuin/|' $H/.dotfiles/config/atuin/config.toml || warn "falhou no atuin"
runuser -u $U -- sed -i 's|"/mnt/cache"|"/mnt/fast"|' $H/.jkyon-terminal/zellij/layouts/portage-panel.kdl || warn "falhou no zellij"
runuser -u $U -- sed -i 's|/home /mnt/cache"|/home /mnt/fast"|' $H/.jkyon-terminal/zsh/shared/alias.zsh || warn "falhou no alias"
for l in .cache .builds Desktop Downloads .local/share/atuin .local/share/baloo; do
    [[ -L $H/$l ]] || { warn "$H/$l não é symlink"; continue; }
    old=$(readlink "$H/$l")
    new=$(sed -E 's#^/mnt/(cache|Desktop|Downloads)#/mnt/fast/\1#' <<< "$old")
    runuser -u $U -- ln -sfn "$new" "$H/$l" && log "  ~/$l -> $new" || warn "symlink ~/$l"
    [[ -e $H/$l ]] || warn "~/$l aponta pra caminho inexistente ($new)"
done
# bees do quickStorage (mascarado desde 2026-08-11): o filesystem não existe mais
rm -f "/etc/systemd/system/beesd@$OLDUUID.service" /etc/bees/quickStorage.conf.disabled
systemctl daemon-reload

# ---------- religa ----------
log "religando loki/prometheus e borg-ui"
docker compose -f "$LOKI" up -d || warn "loki-stack não subiu"
systemctl start borg-ui.service && log "borg-ui ok" || warn "borg-ui não subiu"
docker inspect -f '{{.Name}} {{range .Mounts}}{{.Source}} {{end}}' loki prometheus borg-web-ui 2>/dev/null
findmnt "$MNT"; lsblk /dev/nvme0n1; df -h "$MNT"
btrfs subvolume list "$MNT"
log "staging mantido em $STAGE (apagar depois de conferir: btrfs subvolume delete)"
log "FIM OK"
