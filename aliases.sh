# Aliases by jKyon =)
#
#
# A
alias bashReset='source ~/.bashrc && sleep 1 && reset'
# alias btop='nice -n 19 btop'
#
# B
#
# C
alias clr='clear'
alias copy-to-clipboard='sh ~/ShellScript/Tools/xclip-output-to-clipboard.sh'
alias cp='cp  -v'
alias cupsStart='sudo systemctl start cups.service'
alias cupsStop='sudo systemctl stop cups.service'
#
# D
#
# E
alias ealias='nvim ~/ShellScript/aliases.sh && zshReset'
alias ealacritty='nvim ~/.config/alacritty/alacritty.toml'
alias eawesomeWM='nvim ~/.config/awesome/rc.lua'
alias ebash='nvim ~/.bashrc'
alias edistccHost='nvim ~/.distcc/hosts'
alias efstab='sudo -e ~/.vimrc /etc/fstab'
alias emake='sudo -e ~/.vimrc /etc/portage/make.conf'
alias emskpkg='sudo -e ~/.vimrc /etc/portage/package.accept_keywords'
alias enter-ArchBox='distrobox-enter --root ArchBox'
alias eStartUp='nvim ~/ShellScript/startUpApps.sh'
alias etmux='nvim ~/.dotfiles/.config/tmux/tmux.conf'
alias evim='nvim ~/.vimrc'
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
alias lsblk-mine='lsblk -o NAME,SIZE,FSTYPE,LABEL,MOUNTPOINT'
alias ls='lsd'
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
alias deepShell='sh ~/ShellScript/deepShell.sh'
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
#alias rm='rm -vi'
#
# S
alias satisfactory-server='sh ~/ShellScript/satisfactory-server-update.sh'
alias showSensors='nice --adjustment=19 watch --color --interval 1 sensors'
alias smart-cleanup='sh ~/ShellScript/Tools/jkyon-smart-cleanup.sh'
alias startUpApps='sh ~/ShellScript/startUpApps.sh'
#
# T
#
# U
alias updatePortage='emerge -pvuND @world'
alias upgradePortage='sudo emerge -avuND @world'
alias unmskpkg='sh ~/ShellScript/Tools/gentoo-unmaskPackage.sh'
#
# V
alias valias='bat ~/ShellScript/aliases.sh'
alias valacritty='bat ~/.config/alacritty/alacritty.toml'
alias vawesomeWM='bat ~/.config/awesome/rc.lua'
alias vbash='bat ~/.bashrc'
alias vdistccHost='bat ~/.distcc/hosts'
alias vfstab='bat /etc/fstab'
alias vmake='bat /etc/portage/make.conf'
alias vtmux='bat ~/.dotfiles/.config/tmux/tmux.conf'
alias vumskpkg='bat /etc/portage/package.accept_keywords'
alias vvim='bat ~/.vimrc'
alias vzsh='bat ~/.zshrc'
#
# W
alias wacomSetStylus='xsetwacom set "Wacom Intuos S Pen stylus" MapToOutput DisplayPort-0'
alias watch19='sh ~/ShellScript/Tools/watch19.sh'
alias watchGenlop='nice --adjustment=19 watch --color --interval 1 genlop -ci'
#
# X
#
# Y
#
# Z
alias zshReset='source ~/.zshrc && sleep 1 && reset'
