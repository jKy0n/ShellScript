# Aliases by jKyon =)
#
#
# A
alias bashReset='source ~/.bashrc && sleep 1 && reset'
#
# B
#
# C
alias copy-to-clipboard='sh ~/ShellScript/Tools/xclip-output-to-clipboard.sh'
alias cp='cp  -v'
alias cupsStart='sudo systemctl start cups.service'
alias cupsStop='sudo systemctl stop cups.service'
#
# D
#
# E
alias ealacritty='nvim ~/.config/alacritty/alacritty.toml'
alias ealias='nvim ~/ShellScript/aliases.sh && zshReset'
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
alias ffetch='fastfetch'
#
# G
alias grep='grep --colour=auto'
#
# H
alias helptty='sudo fbset -xres 3440 -yres 1440 && sh ~/ShellScript/Tools/tmux-quickstart.sh'
# alias htop='nice -n 19 htop'
#
# I
#
# J
#
# K
#
# L
alias ls='lsd'
alias lsblk-mine='lsblk -o NAME,SIZE,FSTYPE,LABEL,MOUNTPOINT'
alias lsl='lsd -la'
#
# M
alias meAvise='sh ~/ShellScript/Tools/avisoNoTerminal.sh'
alias mv='mv -v'
#
# N
alias nano='nano --linenumbers'
#
# O
#
# P
# alias pay-respects='_PR_LAST_COMMAND="$(history | tail -n 2 | head -n 1)" /home/jkyon/.local/bin/pay-respects'
alias PicomRestart='sh ~/ShellScript/Tools/picom-restartRoutine.sh'
alias pipewireRestart='sh ~/ShellScript/Tools/pipewire-restart.sh'
#
# Q
#
# R
alias radeontop='radeontop --color --transparency'
alias reboot='loginctl reboot'
#
# S
alias ookla-work='speedtest --server-id=53390'
alias satisfactory-server='sh ~/ShellScript/Games/satisfactory-server-update.sh'
alias sensors='nice --adjustment=19 watch --color --interval 1 sensors'
alias smart-cleanup='sh ~/ShellScript/Tools/jkyon-smart-cleanup.sh'
alias startUpApps='sh ~/ShellScript/startUpApps.sh'
#
# T
#
# U
alias unmskpkg='sh ~/ShellScript/Tools/gentoo-unmaskPackage.sh'
alias updatePortage='emerge -pvuND @world'
alias upgradePortage='sudo emerge -avuND @world'
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
alias genlop='nice --adjustment=19 watch --color --interval 1 genlop -ci'
alias wacomSetStylus='xsetwacom set "Wacom Intuos S Pen stylus" MapToOutput DisplayPort-0'
alias watch19='sh ~/ShellScript/Tools/watch19.sh'
#
# X
#
# Y
#
# Z
alias zshReset='source ~/.zshrc && sleep 1 && reset'
