#!/usr/bin/env bash
#
#        Title:      ephedrine.sh
#        Brief:      Just another caffeine like based on systemd-inhibit
#        Path:       /home/jkyon/ShellScript/Tools/ephedrine/ephedrine.sh
#        Author:     John Kennedy a.k.a. jKyon
#        Created:    2026-06-26
#        Updated:    2026-06-26
#        Notes:      ephedrine - toggle de bloqueio de suspensão (systemd-inhibit) via unit transiente
#

set -euo pipefail

UNIT="ephedrine-lock"
VERSION="1.0"

# Bus de sessão do usuário, necessário pro notify-send funcionar mesmo
# quando o script é chamado via SSH não-interativo (sem env de sessão gráfica)
export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/1000/bus"
ICON="/home/jkyon/Pictures/icons/font-awesome/tablets-solid-full.svg"

notify() {
    notify-send -u normal -i "$ICON" "$1" "$2"
}

cmd_version() {
    echo "ephedrine $VERSION - just another caffeine-like"
}

cmd_help() {
    cat <<EOF
ephedrine is just another caffeine-like based on systemd-inhibit

Use: ephedrine {command}

command examples:
    ephedrine help      -   show this help
    ephedrine version   -   print current version
    ephedrine status    -   show if active or deactive
    ephedrine on        -   turn ephedrine on (suspend blocked)
    ephedrine off       -   turn ephedrine off (suspend rules normally)
EOF
}

is_active() {
    systemctl --user is-active --quiet "$UNIT"
}

cmd_on() {
    if is_active; then
        echo "ephedrine is already active."
        notify "ephedrine" "already active"
        return 0
    fi
    systemd-run --user --unit="$UNIT" \
        --description="Manual block suspension" \
        systemd-inhibit --what=sleep --why="ephedrine manual" --mode=block sleep infinity
    echo "ephedrine active: suspension blocked."
    notify "ephedrine" "suspension blocked"
}

cmd_off() {
    if ! is_active; then
        echo "ephedrine is already deactivated."
        notify "ephedrine status" "already deactivated"
        return 0
    fi
    systemctl --user stop "$UNIT"
    echo "ephedrine deactive: suspension allowed."
    notify "ephedrine deactive" "suspension allowed"
}

cmd_status() {
    if is_active; then
        echo "Activated"
        exit 0
    else
        echo "Deactivated"
        exit 1
    fi
}

cmd_toggle() {
    if is_active; then
        cmd_off
    else
        cmd_on
    fi
}

case "${1:-}" in
    on)      cmd_on ;;
    off)     cmd_off ;;
    status)  cmd_status ;;
    toggle)  cmd_toggle ;;
    version) cmd_version ;;
    help)    cmd_help ;;
    *)
        echo "Use: ephedrine help for more informations" >&2
        exit 2
        ;;
esac