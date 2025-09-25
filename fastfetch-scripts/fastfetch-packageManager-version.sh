#!/usr/bin/env bash

# Detectar a distribuição usando /etc/os-release
if [ -f /etc/os-release ]; then
    . /etc/os-release
    DISTRO=$ID
else
    echo "Não foi possível detectar a distribuição."
    exit 1
fi

# Função para Arch Linux (pacman)
check_arch() {
    # Extrai versões usando pacman -Q
    pacman_version=$(pacman -Q pacman | awk '{print $2}')
    paru_version=$(pacman -Q paru | awk '{print $2}')

    # Se bees não estiver instalado, define como "not installed"
    if [ -z "$paru_version" ]; then
        paru_version="not installed"
    fi

    # Saída formatada
    echo "pacman $pacman_version + paru $paru_version"
}

# Função para Gentoo (portage)
check_gentoo() {
    # Extrair versão do portage
    portage_version=$(qlist -Iv sys-apps/portage 2>/dev/null)
    
    # Verificar se o portage está instalado
    if [ -z "$portage_version" ]; then
        echo "Portage não instalado"
        exit 0
    fi    
    
    # Saída final
    echo "Portage ${portage_version##*-}"
}

# Verificar a distribuição e executar o código correspondente
case $DISTRO in
    arch)
        check_arch
        ;;
    gentoo)
        check_gentoo
        ;;
    *)
        echo "Distribuição não suportada: $DISTRO"
        exit 1
        ;;
esac