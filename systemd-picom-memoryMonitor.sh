#!/bin/bash

# Define o limite de memória em KB (500MB = 500 * 1024)
LIMIT=$((500 * 1024))

# Obtém o uso de memória do picom (em KB)
MEMORY_USAGE=$(ps -C picom -o rss=)

# Verifica se o uso de memória ultrapassa o limite
if [ "$MEMORY_USAGE" -gt "$LIMIT" ]; then
  # Reinicia o picom
  systemctl --user restart jkyon-picom.service
fi
