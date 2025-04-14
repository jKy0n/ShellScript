#!/usr/bin/env bash
# Pastas/origens a incluir no backup:
SRC="/home/jkyon /etc /var/log"   # ajuste conforme necessário
# Repositório do Borg:
REPO="/mnt/backup/borg"

# Nome do host (para identificar nas backups) e timestamp:
HOST=$(uname --nodename)
TIMESTAMP=$(date +'%Y-%m-%d_%H-%M')

# 1. Criação do backup (borg create)
borg create -v --stats                       \
    "$REPO::$HOST-$TIMESTAMP"                \
    $SRC                                     \
    --exclude-caches                         \
    --compression zstd                       \
    --one-file-system

# 2. Prune/expurgo de backups antigos (mantém últimos 24h de hora em hora, últimos 7 dias de diário, etc.)
borg prune -v "$REPO" --glob-archives "$HOST-" --show-rc    \
    --keep-hourly=24   --keep-daily=7   --keep-weekly=4

