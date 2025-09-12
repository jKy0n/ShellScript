#!/usr/bin/env bash

#
#   Use instructions:
#
#     mkdir -p ~/.local/bin                                     # Create a local repositorie
#     ln -s ~/ShellScript/startUpApps.sh ~/.local/bin/startapps # Create SymLink
#     export PATH="$HOME/.local/bin:$PATH"                      # Put path on zsh (or bash)
#     source ~/.zshrc                                           # Uptade shell
#     startapps                                                 # execute
#

HOSTNAME=$(uname -n)  # Use $(uname -n | hostname) - Detecta qual máquina estou usando.

case $HOSTNAME in
    # Start apps on TheseusMachine
    "TheseusMachine")
        fastfetch --config ~/.config/fastfetch/ffetch-TheseusMachine.jsonc
        ;;
    # Start apps on CrisNote
    "CrisNote")
        fastfetch --config ~/.config/fastfetch/ffetch-CrisNote.jsonc
        ;;
    # Start apps on Viamar-PC
    "Viamar-PC")
        fastfetch --config ~/.config/fastfetch/ffetch-viamar-PC.jsonc
        ;;
    *)
        echo "Erro: Hostname '$HOSTNAME' não reconhecido" >&2
        exit 1
        ;;
esac

exit 0
