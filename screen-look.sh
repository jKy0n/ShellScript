#!/usr/bin/env bash

# Configura os tempos de inatividade
xset s 600 600  # 10 minutos para o screensaver
xset dpms 540 540 540  # 9 minutos para desligar tela

# Configura o light-locker para travar após 1 minuto de tela apagada
light-locker \
  --lock-after-screensaver=60 \
  --late-locking \
  --lock-on-suspend \
  --lock-on-lid &
