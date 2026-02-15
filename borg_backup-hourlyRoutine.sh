#!/usr/bin/env bash

# Definições
BACKUP_REPO="/media/backup/jkyon_borgBackup"
BACKUP_TARGET="/home/jkyon"
LOG_FILE="$HOME/.logs/borgBackup/borg_backup.log"


# Executando backup incremental com compressão e deduplicação
borg create --verbose --stats --compression zstd,3 \
    "$BACKUP_REPO"::backup-$(date +%Y-%m-%d_%H:%M) \
    $BACKUP_TARGET >> $LOG_FILE 2>&1

# Remover backups antigos (retenção)
borg prune --keep-hourly=24 --keep-daily=7 --keep-weekly=4 --keep-monthly=6 "$BACKUP_REPO" >> $LOG_FILE 2>&1

# Sincronizar para garantir integridade dos dados no disco
sync

echo "Backup concluído em $(date)" >> $LOG_FILE
exit 0
