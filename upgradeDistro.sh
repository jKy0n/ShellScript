#!/usr/bin/env bash

#
#   Use instructions:  🔽 (rewrite this part) 🔽
#
#     mkdir -p ~/.local/bin                                     # Create a local repositorie
#     ln -s ~/ShellScript/startUpApps.sh ~/.local/bin/startapps # Create SymLink
#     export PATH="$HOME/.local/bin:$PATH"                      # Put path on zsh (or bash)
#     source ~/.zshrc                                           # Uptade shell
#     startapps                                                 # execute
#

# Detecta a distribuição pelo /etc/os-release
if [ -f /etc/os-release ]; then
    . /etc/os-release
    DISTRO=$ID
else
    echo "Não foi possível detectar a distribuição (sem /etc/os-release)" >&2
    exit 1
fi

case "$DISTRO" in
    # Run emerge -pvuND @world
    gentoo)
        sh ~/ShellScript/TheseusMachine/portage-tools/upgrade-portage.sh
        ;;
    # Run paru -Syy && paru -Qu
    arch)
        sh ~/ShellScript/Viamar-PC/upgradeParu.sh
        ;;
    # Run apt upgrade
    *debian*)
        sh ~/ShellScript/Debian/tools/upgrade-apt.sh
        ;;
    *)
        echo "Erro: Distribuição '$DISTRO' não reconhecida" >&2
        exit 1
        ;;
esac

exit 0
