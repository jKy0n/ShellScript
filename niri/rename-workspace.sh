#!/usr/bin/env bash
NOME="$(echo "" | walker --dmenu --inputonly --placeholder "Nome do workspace:")"
[ -n "$NOME" ] && niri msg action set-workspace-name "$NOME"
