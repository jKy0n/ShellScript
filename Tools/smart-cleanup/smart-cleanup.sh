#!/usr/bin/env bash
#
#       Title:      smart-cleanup.sh
#       Brief:      List or delete old temporary files in specified categories.
#       Path:       /home/jkyon/ShellScript/Tools/smart-cleanup/smart-cleanup.sh
#       Author:     John Kennedy a.k.a. jKyon
#       Created:    2026-06-08
#       Updated:    2026-06-08
#       Notes:      
#


# Fail script on any error and notify if an error occurs.
set -e
trap 'notify-send --urgency=critical "jkyon-smart-cleanup: Error" "An error occurred during cleanup. Please check the logs." || true' ERR

# Exclusion list: files or directories that should never be deleted.
EXCLUSIONS=(
    "$HOME/.cache/awesome/history"
    "$HOME/.cache/awmw/todo-widget/todos.json"
    "$HOME/.logs"
)

# Determine mode: dry-run (list) vs delete.
DO_DELETE=false
if [[ "$1" == "--delete" ]]; then
    DO_DELETE=true
fi

# If in delete mode, prepare logging.
if $DO_DELETE; then
    LOGDIR="$HOME/.logs/jkyon-smart-cleanup"
    mkdir -p "$LOGDIR"
    LOGFILE="$(date '+%Y-%m-%d_-_%H:%M_-_jkyon-smart-cleanup.log')"
    LOGPATH="$LOGDIR/$LOGFILE"
    echo "[$(date)] Starting jkyon-smart-cleanup --delete run..." | tee -a "$LOGPATH"
fi

# Helper function to perform find with atime and exclusions.
cleanup_category() {
    local DIR="$1"
    local DAYS="$2"
    local LABEL="$3"
    [[ -d "$DIR" ]] || return 0

    local header="Cleaning $LABEL (files not accessed in over $DAYS days):"
    $DO_DELETE && echo "$header" | tee -a "$LOGPATH" || echo "$header"

    # Monta os predicados de exclusão
    local exclude_args=()
    for EX in "${EXCLUSIONS[@]}"; do
        if [[ "$EX" == "$DIR"* ]]; then
            exclude_args+=( -path "$EX" -prune -o )
        fi
    done

    # Exclusões PRIMEIRO, depois filtros — padrão correto do find
    local find_cmd=(find "$DIR" "${exclude_args[@]}" -type f -atime +"$DAYS")

    if $DO_DELETE; then
        "${find_cmd[@]}" -print -delete | tee -a "$LOGPATH"
    else
        "${find_cmd[@]}" -print
    fi
}

# Perform cleanup for each category with specified age threshold.
cleanup_category "$HOME/.cache"                   30 ".cache"
cleanup_category "$HOME/.local/share/Trash/files" 60 "Trash/files"
cleanup_category "$HOME/.thumbnails"               7 ".thumbnails"
cleanup_category "$HOME/.local/state"             30 ".local/state"
# cleanup_category "$HOME/.config/rambox/Cache"     16 "rambox/Cache (global)"
# cleanup_category "$HOME/.config/rambox/GPUCache"  16 "rambox/GPUCache"

if $DO_DELETE; then
    echo "[$(date)] Cleanup run complete." | tee -a "$LOGPATH"
fi

exit 0
