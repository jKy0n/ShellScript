#!/bin/bash
if makoctl mode | grep -q "^dnd$"; then
    echo '{"text": "", "class": "active", "tooltip": "DND ativo — clique pra desligar"}'
else
    echo '{"text": "", "class": "", "tooltip": "DND desligado — clique pra ligar"}'
fi
