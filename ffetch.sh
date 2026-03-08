#!/usr/bin/env bash


if command -v getprop >/dev/null 2>&1; then
    MACHINE_ID="$(getprop ro.product.model)"
else
    MACHINE_ID="$(uname -n)"
fi

# Verifica se foi passado --mini ou -m como argumento
MINI=false
for arg in "$@"; do
    if [[ "$arg" == "--mini" || "$arg" == "-m" ]]; then
        MINI=true
        break
    fi
done

case $MACHINE_ID in
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

    # Call fastfetch for Poco C65
    "Poco C65"|"Xiaomi Poco C65"|"2310FPCA4I")
        if $MINI; then
            echo "Modo mini para Poco C65 ainda não configurado."
            # fastfetch --config ~/.config/fastfetch/ffetch-mini-poco-c65.jsonc
        else
            # echo "Modo completo para Poco C65 ainda não configurado."
            fastfetch --config ~/.config/fastfetch/ffetch-poco-c65.jsonc
        fi
        ;;

    *)
        echo "Erro: máquina '$MACHINE_ID' não reconhecida" >&2
        exit 1
        ;;
esac

exit 0
