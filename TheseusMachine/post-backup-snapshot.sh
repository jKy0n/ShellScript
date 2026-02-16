#!/usr/bin/env bash

# ===================================================================
# Script de Integração: Borg-UI -> Snapper
# ===================================================================
# Este script é chamado pelo borg-ui após a conclusão de um backup.
# Ele verifica se o backup foi bem-sucedido e, em caso afirmativo,
# cria um snapshot do repositório de backup usando o Snapper.
# ===================================================================

# --- Configuração ---
SNAPPER_CONFIG="backup" # O nome da configuração do Snapper que você criou
LOG_FILE="/home/jkyon/.logs/borg-ui_snapper_integration.log"

# --- Funções ---
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

# --- Verificações Iniciais ---
# Garante que o script não vai rodar se não for chamado pelo borg-ui
if [ -z "$BORG_REPO" ] || [ -z "$BORG_ARCHIVE" ]; then
    log "ERRO: Este script deve ser chamado pelo borg-ui (variáveis BORG_* não encontradas)."
    exit 1
fi

# --- Lógica Principal ---
log "-----------------------------------------------------"
log "Script de pós-backup iniciado para o arquivo: $BORG_ARCHIVE"
log "Código de saída do Borg: $BORG_EXIT_CODE"

# Verifica se o backup foi bem-sucedido (código de saída 0)
if [ "$BORG_EXIT_CODE" -eq 0 ]; then
    log "Backup bem-sucedido. Criando snapshot do repositório..."

    # Cria o snapshot com uma descrição informativa
    # É importante usar o caminho completo para o snapper para garantir que o systemd o encontre
    /usr/bin/snapper -c "$SNAPPER_CONFIG" create --description "Pós-backup: $BORG_ARCHIVE"

    SNAPPER_EXIT_CODE=$?
    if [ "$SNAPPER_EXIT_CODE" -eq 0 ]; then
        log "Snapshot criado com sucesso."
    else
        log "ERRO: Falha ao criar o snapshot. Código de saída do Snapper: $SNAPPER_EXIT_CODE"
    fi
else
    log "Backup falhou ou foi cancelado. Nenhum snapshot será criado."
fi

log "Script de pós-backup finalizado."
log "-----------------------------------------------------"

exit 0
