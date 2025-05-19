#!/usr/bin/env bash
#
zsh_version=$(zsh --version | awk '{print $1, $2}')
tmux_version=$(tmux -V | awk '{print $1, $2}')
echo "$zsh_version + $tmux_version"

