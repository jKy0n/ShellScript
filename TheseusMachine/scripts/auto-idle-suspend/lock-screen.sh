#!/usr/bin/env bash
set -eu

# Acorda o monitor antes do lock, se ele já tiver apagado
xset dpms force on || true

# Tenta o fancy-rapid; se falhar, cai para i3lock puro
if command -v i3lock-fancy-rapid >/dev/null 2>&1; then
  exec i3lock-fancy-rapid 7 3
else
  exec i3lock --nofork -c 11111b
fi
