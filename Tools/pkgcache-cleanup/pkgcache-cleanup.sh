#!/usr/bin/env bash
#
#       Title:      pkgcache-cleanup.sh
#       Brief:      Universal package cache cleanup (pacman / portage).
#       Path:       /home/jkyon/ShellScript/Tools/pkgcache-cleanup/pkgcache-cleanup.sh
#       Author:     John Kennedy a.k.a. jKyon
#       Notes:      Cross-machine — auto-detects pacman (Arch) or portage (Gentoo).
#                    Runs as root (system-level systemd unit).
#

set -e

LOGDIR="/var/log/jkyon-pkgcache-cleanup"
mkdir -p "$LOGDIR"
LOGFILE="$LOGDIR/$(date '+%Y-%m-%d_%H%M').log"

log() { echo "[$(date)] $*" | tee -a "$LOGFILE"; }

# Notifica a sessão gráfica do jkyon, se houver uma ativa (silencioso em headless, ex: Builder)
notify() {
    local uid
    uid=$(id -u jkyon 2>/dev/null) || return 0
    [[ -S "/run/user/$uid/bus" ]] || return 0
    sudo -u jkyon DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$uid/bus" \
        notify-send "$@" || true
}

if command -v pacman >/dev/null 2>&1; then
    log "Detectado pacman (Arch). Aparando cache..."
    BEFORE=$(du -sh /var/cache/pacman/pkg 2>/dev/null | cut -f1)
    paccache -rk2 | tee -a "$LOGFILE"      # mantém 2 versões dos instalados
    paccache -ruk0 | tee -a "$LOGFILE"     # remove tudo dos NÃO instalados
    AFTER=$(du -sh /var/cache/pacman/pkg 2>/dev/null | cut -f1)
    log "Cache pacman: $BEFORE -> $AFTER"
    notify "Cache cleanup" "pacman: $BEFORE -> $AFTER"

elif command -v emerge >/dev/null 2>&1; then
    log "Detectado portage (Gentoo). Limpando distfiles/binpkgs..."
    if command -v eclean-dist >/dev/null 2>&1; then
        BEFORE=$(du -sh /var/cache/distfiles 2>/dev/null | cut -f1)
        eclean-dist | tee -a "$LOGFILE"
        AFTER=$(du -sh /var/cache/distfiles 2>/dev/null | cut -f1)
        log "distfiles: $BEFORE -> $AFTER"
    else
        log "AVISO: app-portage/gentoolkit não instalado — pulando distfiles (instale pra habilitar)"
    fi
    if command -v eclean-pkg >/dev/null 2>&1 && [[ -d /var/cache/binpkgs ]]; then
        eclean-pkg | tee -a "$LOGFILE"
    fi
    notify "Cache cleanup" "portage cleanup completo"

else
    log "Nenhum gerenciador conhecido (pacman/portage) detectado — nada a fazer."
fi

log "Concluído."
exit 0
