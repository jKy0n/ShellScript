#!/usr/bin/env bash
#
#        Title:      ShellScripts-git-sync.sh
#        Brief:
#        Path:       /home/jkyon/ShellScript/systemd/ShellScripts-git-sync/ShellScripts-git-sync.sh
#        Author:     John Kennedy a.k.a. jKyon
#        Created:    2026-06-22
#        Updated:    2026-06-22
#        Notes:
#

set -u

NAME="ShellScripts-git-sync"
REPO="$HOME/ShellScript"

LOG_DIR="$HOME/.logs/$NAME"
LOG_FILE="$LOG_DIR/${NAME}-error.log"
MAX_LOG_LINES=200

timestamp() {
    date '+%Y-%m-%d %H:%M:%S'
}

trim_log() {
    [[ -f "$LOG_FILE" ]] || return 0

    local tmp
    tmp="$(mktemp)"

    tail -n "$MAX_LOG_LINES" "$LOG_FILE" > "$tmp" && mv "$tmp" "$LOG_FILE"
}

log_error() {
    mkdir -p "$LOG_DIR"

    {
        echo
        echo "[$(timestamp)] ERRO em $(hostname -s)"
        echo "$1"
    } >> "$LOG_FILE"

    trim_log
}

notify_error() {
    command -v notify-send >/dev/null 2>&1 || return 0

    notify-send \
        -u critical \
        -a "$NAME" \
        "❌ $NAME falhou" \
        "Erro ao atualizar $REPO. Log: $LOG_FILE" \
        >/dev/null 2>&1 || true
}

main() {
    local output
    local status

    output="$(git -C "$REPO" pull --ff-only 2>&1)"
    status=$?

    if (( status != 0 )); then
        log_error "$output"
        notify_error
        return "$status"
    fi

    return 0
}

main "$@"