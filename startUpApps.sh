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

HOSTNAME=$(hostname)  # Ou use $(uname -n) - Detecta qual máquina estou usando.

case $HOSTNAME in
    # Start apps on TheseusMachine
    "TheseusMachine")
        "$HOME/ShellScript/startUpApps-TheseusMachine.sh"
        ;;
    # Start apps on CrisNote
    "CrisNote")
        "$HOME/ShellScript/startUpApps-CrisNote.sh"
        ;;
    # Start apps on Viamar-PC
    "Viamar-PC")
        "$HOME/ShellScript/startUpApps-Viamar-PC.sh"
        ;;
    *)
        echo "Erro: Hostname '$HOSTNAME' não reconhecido" >&2
        exit 1
        ;;
esac

exit 0
