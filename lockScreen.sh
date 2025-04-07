#!/usr/bin/env bash


# =============================================
# Tempos em Segundos
# =============================================
SCREEN_OFF=3540   # 59 minutos = 3540 segundos (tela apaga)
LOCK_DELAY=60    # +1 minuto = 60 segundos (trava)

# =============================================
# Configuração do X Server
# =============================================
xset s $SCREEN_OFF
xset dpms 0 0 $SCREEN_OFF
xset s blank

# =============================================
# Inicia light-locker com delay de 60s após screensaver
# =============================================
light-locker --lock-after-screensaver=$LOCK_DELAY &
