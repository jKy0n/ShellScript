#!/usr/bin/env bash
#
terminal_version=$(alacritty --version | awk '{print $1, $2}')
zsh_version=$(zsh --version | awk '{print $1, $2}')
tmux_version=$(tmux -V | awk '{print $1, $2}')
echo "$terminal_version + $zsh_version + $tmux_version"