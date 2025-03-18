#!/usr/bin/bash
# ollama-pretty.sh
query="$*"  # Captura todos os argumentos como consulta
ollama run deepseek-r1 "$query" | \
  sed -e "s/^/# /" | \
  awk '{printf "\033[38;5;213m%s\033[0m\n", $0}'  # Formatação rosa
