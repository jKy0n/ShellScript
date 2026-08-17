#!/usr/bin/env bash
# filepath: /home/jkyon/ShellScript/Viamar-PC/upgradeParu.sh
# Verifica se o paru está instalado
#if ! command -v paru &> /dev/null; then
#     echo "Paru não está instalado. Instale com: sudo pacman -S paru"
#     exit 1
#fi
# Atualiza os repositórios e mostra atualizações disponíveis
sudo emerge -vauND @world
EXIT_CODE=$?

# So atualiza o cache/waybar se o merge terminou de verdade, com sucesso.
# --pretend nunca passa por aqui (mora em outro script); interrupcao ou
# erro real (exit != 0) preserva o cache antigo em vez de zerar a lista
# como se tudo tivesse sido resolvido.
if [ "$EXIT_CODE" -eq 0 ]; then
    echo ""
    echo "Merge concluido com sucesso - atualizando cache da waybar..."
    sudo /usr/local/bin/refresh-portage-cache.sh
else
    echo ""
    echo "Merge terminou com erro ou foi interrompido (exit ${EXIT_CODE}) - cache NAO atualizado."
fi

exit "$EXIT_CODE"
