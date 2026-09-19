#!/usr/bin/env bash
#
terminal_version=$($TERMINAL --version | awk '{print $1, $2}')
zsh_version=$(zsh --version | awk '{print $1, $2}')
zellij_version=$(zellij --version | awk '{print $1, $2}')
echo "$terminal_version + $zsh_version + $zellij_version"
