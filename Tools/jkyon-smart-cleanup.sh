#!/usr/bin/env bash
# jkyon-smart-cleanup.sh: List or delete old temporary files in specified categories.

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
  [[ -d "$DIR" ]] || return 0  # skip if directory doesn't exist
  # Print header for this category
  local header="Cleaning $LABEL (files not accessed in over $DAYS days):"
  if $DO_DELETE; then
    echo "$header" | tee -a "$LOGPATH"
  else
    echo "$header"
  fi
  # Build the find command with exclusions
  local find_cmd=(find "$DIR" -type f -atime +"$DAYS")
  for EX in "${EXCLUSIONS[@]}"; do
    # Only exclude if the path is within the target DIR
    if [[ "$EX" == "$DIR"* ]]; then
      find_cmd+=( -path "$EX" -prune -o )
    fi
  done
  # Complete the find command: after pruning exclusions, match files by atime
  find_cmd+=( -type f -atime +"$DAYS" )
  # In dry-run mode, just list the files. In delete mode, delete and log each file.
  if $DO_DELETE; then
    "${find_cmd[@]}" -print -delete | tee -a "$LOGPATH"
  else
    "${find_cmd[@]}" -print
  fi
}

# Perform cleanup for each category with specified age threshold.
cleanup_category "$HOME/.cache"            30 ".cache"
cleanup_category "$HOME/.local/share/Trash/files" 60 "Trash/files"
cleanup_category "$HOME/.thumbnails"       7  ".thumbnails"
cleanup_category "$HOME/.local/state"      30 ".local/state"

if $DO_DELETE; then
  echo "[$(date)] Cleanup run complete." | tee -a "$LOGPATH"
fi

exit 0