#!/usr/bin/env bash
#
#
echo "Parando PipeWire e serviços relacionados..."
systemctl --user stop pipewire pipewire-pulse wireplumber
#
echo "Aguardando 5 segundos..."
sleep 5
#
echo "Iniciando PipeWire e serviços relacionados..."
systemctl --user start pipewire pipewire-pulse wireplumber
#
echo "Reinício do PipeWire concluído!"
