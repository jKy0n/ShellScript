#!/usr/bin/env bash
NOME="$(echo "" | rofi -dmenu -p "Nome do workspace:" -l 0)"
[ -n "$NOME" ] && niri msg action set-workspace-name "$NOME"
