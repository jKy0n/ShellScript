# shellcheck shell=bash
#
#        Title:      aliases.sh
#        Brief:      My custom aliases for the terminal
#        Path:       /home/jkyon/ShellScript/aliases.sh
#        Author:     John Kennedy a.k.a. jKyon
#        Created:    2026-02-23
#        Updated:    2026-03-15
#        Notes:      All the aliases I use in the terminal, organized alphabetically by the command they alias.
#                    Some of these aliases are just for fun, while others are meant to improve my workflow and productivity.
#                    Feel free to use any of these aliases or modify them to suit your needs!
#
#
#
# A
alias bash-reset='source ~/.bashrc && sleep 1 && reset'
#
# B
alias bulk-ocr='/home/jkyon/ShellScript/Tools/bulk-ocr/bulk-ocr.sh'
#
# C
alias copy-to-clipboard-alias='sh ~/ShellScript/Tools/xclip-output-to-clipboard/xclip-output-to-clipboard.sh'
alias cp='cp -v'
#
# D
alias dead-process-watcher='watch19 '\''ps -eo ppid,pid,stat,comm | grep " D" && ps -eo ppid,pid,stat,comm | grep " Z"'\'
alias distcc-portage-watch='nice --adjustment=19 env DISTCC_DIR=/var/tmp/portage/.distcc distccmon-text 1'
#
# E
alias ealacritty='nvim ~/.config/alacritty/alacritty.toml'
alias ealias='nvim ~/ShellScript/aliases.sh && zsh-reset'
alias eawesomeWM='nvim ~/.config/awesome/rc.lua'
alias ebash='nvim ~/.bashrc'
alias efstab='sudo -e /etc/fstab'
alias emake='sudo -e /etc/portage/make.conf'
alias eStartUp='nvim ~/ShellScript/startUpApps.sh'
alias etmux='nvim ~/.dotfiles/.config/tmux/tmux.conf'
alias eUnmskpkg='sudo -e /etc/portage/package.accept_keywords'
alias ezsh='nvim ~/.zshrc'
#
# F
alias ffetch='sh ~/ShellScript/ffetch.sh'
#
# G
alias genlop-watch='nice --adjustment=19 watch --color --interval 1 genlop -ci'
alias grep='grep --colour=auto'
#
# H
# alias helptty='sudo fbset -xres 3440 -yres 1440 && sh ~/ShellScript/Tools/tmux-quickstart.sh'
#
# I
alias iotop='sudo iotop -aoP'
#
# J
alias jkyonphone-ssh-mount='mkdir -p /mnt/jKyonPhone && sshfs \
    jkyonphone:/data/data/com.termux/files/home \
    /mnt/jKyonPhone \
    -o reconnect \
    -o follow_symlinks \
    -o cache=yes \
    -o kernel_cache'

alias jkyonphone-ssh-umount='fusermount3 -u /mnt/jKyonPhone || fusermount -u /mnt/jKyonPhone'
#
# K
#
# L
alias ls='lsd'
alias lsblk-mine='lsblk -o NAME,SIZE,FSTYPE,LABEL,MOUNTPOINT'
alias lsl='lsd -l'
alias lsla='lsd -la'
alias lsusb='echo "Use cyme instead: cyme --tree"'
#
# M
alias man='LANG=pt_BR.UTF-8 man'
alias me-avise='sh ~/ShellScript/Tools/avisoNoTerminal.sh'
alias mv='mv -v'
#
# N
#
# O
alias ookla-home='ookla-speedtest --server-id=53390'
alias ookla-work='speedtest --server-id=53390'
#
# P
alias picom-restart='sh ~/ShellScript/Tools/picom-restartRoutine.sh'
alias pipewire-restart='sh ~/ShellScript/Tools/pipewire-restart.sh'
alias portage-unused-ranker='sh /home/jkyon/ShellScript/TheseusMachine/portage-tools/portage-unused-ranker/portage-unused-ranker.sh'
#
# Q
#
# R
alias radeontop='radeontop --color --transparency'
alias reboot='loginctl reboot'
alias rg='rg --color=auto'
#
# S
alias satisfactory-server='sh ~/ShellScript/Games/satisfactory-server-update.sh'
alias sensors-watch='nice --adjustment=19 watch --interval 3 --differences sensors'
alias smart-cleanup='sh ~/ShellScript/Tools/jkyon-smart-cleanup.sh'
alias start-up-apps='sh ~/ShellScript/startUpApps.sh'
#
# T
#
# U
alias unmskpkg='sh ~/ShellScript/Tools/gentoo-unmaskPackage.sh'
alias update-distro='sh ~/ShellScript/updateDistro.sh'
alias upgrade-distro='sh ~/ShellScript/upgradeDistro.sh'
alias upgrade-kernel='sh ~/ShellScript/TheseusMachine/tools/upgrade-kernel/upgrade-kernel.sh'
#
# V
alias valacritty='bat ~/.config/alacritty/alacritty.toml'
alias valias='bat ~/ShellScript/aliases.sh'
alias vbash='bat ~/.bashrc'
alias vfstab='bat /etc/fstab'
alias vmake='bat /etc/portage/make.conf'
alias vumskpkg='bat /etc/portage/package.accept_keywords'
#
# W
alias wacom-set-stylus='xsetwacom set "Wacom Intuos S Pen stylus" MapToOutput DisplayPort-0'
alias watch19='sh ~/ShellScript/Tools/watch19.sh'
#
# X
#
# Y
#
# Z
alias zsh-reset='source ~/.zshrc && sleep 1 && reset'
