#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../lib/detect-distro.sh"

distro="$(detect_distro)"

case "$distro" in
    arch)
        bat /etc/makepkg.conf
        ;;
    gentoo)
        bat /etc/portage/make.conf
        ;;
    *)
        echo "vmake: distro não suportada (esperado Arch ou Gentoo)." >&2
        exit 1
        ;;
esac
