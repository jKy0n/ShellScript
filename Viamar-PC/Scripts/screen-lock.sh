#!/usr/bin/env bash

# =============================================
# Tempos em Segundos
# =============================================
# SCREEN_OFF=590   # 9 minutos = 540 segundos (tela apaga)
# LOCK_DELAY=10    # +1 minuto = 60 segundos (trava)
# LOCK_SESSION=600  # 10 minutos = 600 segundos (trava sessão)

# =============================================
# Configuração do X Server
# =============================================
# xset s $SCREEN_OFF
# xset dpms 0 0 $SCREEN_OFF
# xset s blank

# =============================================
# Inicia light-locker com delay de 10s após screensaver
# =============================================
# light-locker --lock-after-screensaver=60 &
# =============================================


# NOTE: Versão 2.0
# ============================================

set -euo pipefail

user="jkyon"
session=$(loginctl list-sessions | grep "$user" | awk '{print $1}' | head -n1)

if [[ -n "$session" ]]; then
    loginctl lock-session "$session"
else
    echo "No active session found for user $user"
fi