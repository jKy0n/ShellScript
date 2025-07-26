#!/bin/bash

# setup up phase
SRC="/etc"
DEST="$HOME/.theseusMachine-core/etc"
FILTER="$HOME/.config/theseus/rsync-filter"

{ # Sync phase
    mkdir -p "$DEST" &&
    rsync -av --delete --filter="dir-merge,$FILTER" "$SRC/" "$DEST/" &&
    cd "$HOME/.theseusMachine-core" &&
# Git phase    
    git add . &&
    git diff --cached --quiet || git commit -m "Sync configs $(date +'%Y-%m-%d %H:%M')" &&
    git push
# if error, notify
} || notify-send -u critical "Erro ao sincronizar /etc" "Backup e commit dos arquivos de configuração falhou!"
