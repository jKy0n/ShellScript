#!/usr/bin/env bash
# Coleta dados do sistema sem dependências gráficas
RAM=$(free -h | awk '/Mem/{print $3 "/" $2}')
CPU=$(grep 'cpu MHz' /proc/cpuinfo | head -n 1 | awk '{printf "%.1f GHz", $4/1000}')
PKGS=$(qlist -I | wc -l)

# Formata para o Ollama
echo "[INST] Contexto atual:
- Sistema: uname --operational-system
- RAM: $RAM
- CPU (Ryzen 9 5950X): $CPU
- Pacotes instalados: $PKGS
- Shell: bash
[/INST]"
