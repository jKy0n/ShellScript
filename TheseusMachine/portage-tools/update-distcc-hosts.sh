#!/bin/bash

# /usr/local/bin/update-distcc-hosts.sh
# Este script gera dinamicamente o arquivo de configuração de hosts do distcc para o Portage.
# Ele testa a conectividade para priorizar a LAN sobre o Tailscale.

# Arquivo de saída que será lido pelo make.conf
OUTPUT_FILE="/etc/portage/distcc.conf"

# Inicia a lista de hosts com a máquina local (TheseusMachine).
DISTCC_HOSTS="192.168.15.10/28 100.100.10.10/28"

# Definições dos hosts remotos
HOST_DEFINITIONS=(
    "192.168.5.20 100.100.10.20 10" # Viamar-PC
    "192.168.15.30 100.100.10.30 8"  # Crisnote
)

# Itera sobre cada máquina para verificar a conectividade.
for host_def in "${HOST_DEFINITIONS[@]}"; do
    read -r lan_ip tailscale_ip threads <<<"$host_def"

    # Tenta pingar o IP da LAN com um timeout curto (1 segundo).
    if ping -c 1 -W 1 "$lan_ip" &>/dev/null; then
        DISTCC_HOSTS+=" $lan_ip/$threads"
    else
        DISTCC_HOSTS+=" $tailscale_ip/$threads"
    fi
done

# Gera o arquivo de configuração final para o Portage.
# O comentário ajuda a identificar quando o arquivo foi atualizado pela última vez.
echo "# Gerado automaticamente por update-distcc-hosts.sh em $(date)" > "$OUTPUT_FILE"
echo "DISTCC_HOSTS=\"$DISTCC_HOSTS\"" >> "$OUTPUT_FILE"

echo "Arquivo $OUTPUT_FILE atualizado com sucesso:"
echo "$DISTCC_HOSTS"
