#!/usr/bin/env bash


# =============================================
# Tempos em Segundos
# =============================================
SCREEN_OFF=590   # 9 minutos = 540 segundos (tela apaga)
LOCK_DELAY=10    # +1 minuto = 60 segundos (trava)

# =============================================
# Configuração do X Server
# =============================================
xset s $SCREEN_OFF
xset dpms 0 0 $SCREEN_OFF
xset s blank

# =============================================
# Inicia light-locker com delay de 10s após screensaver
# =============================================
light-locker --lock-after-screensaver=10 &