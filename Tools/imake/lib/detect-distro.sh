#!/usr/bin/env bash
# detect-distro.sh — detecta a distro atual (arch | gentoo | unknown)
# Uso: source este arquivo e chame detect_distro

detect_distro() {
    local id=""
    if [[ -r /etc/os-release ]]; then
        id="$(source /etc/os-release; echo "$ID")"
    fi

    case "$id" in
        arch)   echo "arch";   return 0 ;;
        gentoo) echo "gentoo"; return 0 ;;
    esac

    # Fallback: se os-release falhar/faltar, decide pelo gerenciador de pacotes
    if command -v pacman &>/dev/null; then
        echo "arch"
    elif command -v emerge &>/dev/null; then
        echo "gentoo"
    else
        echo "unknown"
    fi
}
