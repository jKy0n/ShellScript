#!/usr/bin/env bash


HOSTNAME=$(uname -n)

# Verifica se foi passado --mini ou -m como argumento
MINI=false
for arg in "$@"; do
    if [[ "$arg" == "--mini" || "$arg" == "-m" ]]; then
        MINI=true
        break
    fi
done

case $HOSTNAME in
    # Call fastfetch for CrisNote
    "CrisNote")
        if $MINI; then
            fastfetch --config ~/.config/fastfetch/ffetch-mini-CrisNote.jsonc
        else
            fastfetch --config ~/.config/fastfetch/ffetch-CrisNote.jsonc
        fi
        ;;

    # Call fastfetch for TheseusMachine
    "TheseusMachine")
        if $MINI; then
            fastfetch --config ~/.config/fastfetch/ffetch-mini-TheseusMachine.jsonc
        else
            fastfetch --config ~/.config/fastfetch/ffetch-TheseusMachine.jsonc
        fi
        ;;

    # Call fastfetch for Viamar-PC
    "Viamar-PC")
        if $MINI; then
            fastfetch --config ~/.config/fastfetch/ffetch-mini-viamar-PC.jsonc
        else
            fastfetch --config ~/.config/fastfetch/ffetch-viamar-PC.jsonc
        fi
        ;;
    *)
        echo "Erro: Hostname '$HOSTNAME' não reconhecido" >&2
        exit 1
        ;;
esac

exit 0
