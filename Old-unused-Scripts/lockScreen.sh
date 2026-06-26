#!/usr/bin/env bash


# =============================================
# Tempos em Segundos (Ajuste para LOCK imediato)
# =============================================
SCREEN_OFF=3540   # 59m → Tela desliga
LOCK_DELAY=0       # 0s → Trava Imediatamente após o screensaver

# =============================================
# Configura DPMS e Screensaver
# =============================================
xset s $SCREEN_OFF          # Screensaver inicia após 59m
xset s blank                # Tela preta ao invés de "X"
xset dpms $SCREEN_OFF $SCREEN_OFF $SCREEN_OFF  # standby | suspend | off
xset +dpms                  # Habilita DPMS (crítico!)

# =============================================
# Inicia light-locker com LOCK imediato após screensaver
# =============================================
light-locker --lock-after-screensaver=$LOCK_DELAY &