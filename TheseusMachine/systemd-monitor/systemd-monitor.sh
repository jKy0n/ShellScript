#!/bin/bash

################################################################################
# systemd-monitor.sh
# 
# Script para monitorar serviços systemd falhados e enviar notificações
# via notify-send quando um serviço entra em estado "failed"
#
# Uso: ./systemd-monitor.sh
# 
# Dependências:
#   - systemctl (systemd)
#   - notify-send (libnotify)
#   - jq (opcional, para parsing JSON)
#
# Instalação:
#   1. Copiar este script para ~/.local/bin/systemd-monitor.sh
#   2. chmod +x ~/.local/bin/systemd-monitor.sh
#   3. Copiar systemd-monitor.service e systemd-monitor.timer para ~/.config/systemd/user/
#   4. systemctl --user daemon-reload
#   5. systemctl --user enable --now systemd-monitor.timer
#
################################################################################

set -euo pipefail

# Configurações
LOG_DIR="${HOME}/.logs/systemd-monitor"
CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}"
MONITOR_CACHE="${CACHE_DIR}/systemd-monitor"
FAILED_SERVICES_CACHE="${MONITOR_CACHE}/failed-services.txt"
MONITOR_LOG="${LOG_DIR}/monitor.log"
NOTIFICATION_TIMEOUT=10000  # milissegundos
NOTIFICATION_URGENCY="critical"  # low, normal, critical

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Criar diretórios se não existirem
mkdir -p "${LOG_DIR}"
mkdir -p "${MONITOR_CACHE}"

################################################################################
# Funções
################################################################################

# Log com timestamp
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" >> "${MONITOR_LOG}"
}

# Enviar notificação
send_notification() {
    local title="$1"
    local message="$2"
    local urgency="${3:-$NOTIFICATION_URGENCY}"
    
    notify-send \
        --urgency="${urgency}" \
        --expire-time="${NOTIFICATION_TIMEOUT}" \
        --app-name="systemd-monitor" \
        --icon="dialog-warning" \
        "${title}" \
        "${message}"
    
    log "Notificação enviada: ${title} - ${message}"
}

# Obter lista de serviços falhados
get_failed_services() {
    systemctl list-units --failed --no-pager --output=json 2>/dev/null | \
        jq -r '.[] | .unit' 2>/dev/null || \
        systemctl list-units --failed --no-pager 2>/dev/null | \
        grep -oP '^\s*●\s+\K[^\s]+' || \
        true
}

# Obter status detalhado de um serviço
get_service_status() {
    local service="$1"
    systemctl status "${service}" --no-pager 2>&1 | head -15 || true
}

# Comparar com cache anterior
check_new_failures() {
    local current_failed="$1"
    local previous_failed=""
    
    # Ler serviços falhados anteriores do cache
    if [[ -f "${FAILED_SERVICES_CACHE}" ]]; then
        previous_failed=$(cat "${FAILED_SERVICES_CACHE}")
    fi
    
    # Salvar estado atual
    echo "${current_failed}" > "${FAILED_SERVICES_CACHE}"
    
    # Encontrar novos serviços falhados
    if [[ -z "${previous_failed}" ]]; then
        # Primeira execução
        echo "${current_failed}"
    else
        # Comparar e encontrar diferenças
        comm -23 <(echo "${current_failed}" | sort) <(echo "${previous_failed}" | sort)
    fi
}

# Obter informações detalhadas de um serviço
get_service_info() {
    local service="$1"
    
    # Tentar obter informações com systemctl
    local status_output
    status_output=$(systemctl status "${service}" --no-pager 2>&1 | head -20)
    
    # Extrair informações relevantes
    local active_status
    active_status=$(echo "${status_output}" | grep -oP 'Active: \K.*' | head -1 || echo "Unknown")
    
    local last_error
    last_error=$(journalctl -u "${service}" -n 1 --no-pager 2>&1 | tail -1 || echo "No logs available")
    
    echo "Status: ${active_status}"
    echo "Último erro: ${last_error}"
}

################################################################################
# Main
################################################################################

main() {
    log "=== Iniciando verificação de serviços falhados ==="
    
    # Obter lista de serviços falhados
    failed_services=$(get_failed_services)
    
    if [[ -z "${failed_services}" ]]; then
        log "✓ Nenhum serviço falhado detectado"
        exit 0
    fi
    
    # Verificar novos serviços falhados
    new_failures=$(check_new_failures "${failed_services}")
    
    if [[ -z "${new_failures}" ]]; then
        log "ℹ Serviços falhados já conhecidos, sem novas falhas"
        exit 0
    fi
    
    # Processar cada novo serviço falhado
    while IFS= read -r service; do
        if [[ -z "${service}" ]]; then
            continue
        fi
        
        log "⚠ Novo serviço falhado detectado: ${service}"
        
        # Obter informações do serviço
        service_info=$(get_service_info "${service}")
        
        # Preparar mensagem de notificação
        local title="Serviço Falhado: ${service}"
        local message="${service_info}"
        
        # Enviar notificação
        send_notification "${title}" "${message}" "critical"
        
        # Log detalhado
        log "Detalhes do serviço ${service}:"
        log "${service_info}"
        
    done <<< "${new_failures}"
    
    log "=== Verificação concluída ==="
}

# Executar main
main "$@"
