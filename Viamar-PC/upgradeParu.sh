#!/usr/bin/env bash
# filepath: /home/jkyon/ShellScript/Viamar-PC/upgradeParu.sh

# Verifica se o paru está instalado
if ! command -v paru &> /dev/null; then
     echo "Paru não está instalado. Instale com: sudo pacman -S paru"
     exit 1
fi

# Atualiza os repositórios e mostra atualizações disponíveis
paru -Syyuu --noconfirm
EXIT_CODE=$?

# Só atualiza o contador da waybar se o upgrade terminou de verdade, com
# sucesso — evita zerar o ícone se o upgrade for interrompido/falhar.
if [ "$EXIT_CODE" -eq 0 ]; then
    echo "Upgrade concluído com sucesso - atualizando contador da waybar..."
    pkill -RTMIN+9 waybar || true
else
    echo "Upgrade terminou com erro ou foi interrompido (exit ${EXIT_CODE}) - contador NÃO atualizado."
fi
exit "$EXIT_CODE"
