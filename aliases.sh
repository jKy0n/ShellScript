# Aliases by jKyon =)
#
#
# A
alias bashReset='source ~/.bashrc && sleep 1 && reset'
alias btop='nice -n 19 btop'
#
# B
#
# C
alias clr='clear'
alias cp='cp  -v'
alias cupsStart='sudo rc-service cupsd start'
alias cupsStop='sudo rc-service cupsd stop'
#
# D
#
# E
alias ealias='nvim ~/ShellScript/aliases.sh && zreset'
alias ealacritty='nvim ~/.config/alacritty/alacritty.toml'
alias eawesomeWM='nvim ~/.config/awesome/rc.lua'
alias ebash='nvim ~/.bashrc'
alias edistccHost='nvim ~/.distcc/hosts'
alias efstab='sudo -e ~/.vimrc /etc/fstab'
alias emake='sudo -e ~/.vimrc /etc/portage/make.conf'
alias emskpkg='sudo -e ~/.vimrc /etc/portage/package.accept_keywords'
alias enter-ArchBox='distrobox-enter --root ArchBox'
alias eStartUp='nvim ~/ShellScript/startUpApps.sh'
alias eToInstallList='nvim ~/ShellScript/gentoo-toInstall.txt'
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
alias helptty='sudo fbset -xres 3440 -yres 1440 && sh ~/ShellScript/tmux-quickstart.sh'
alias htop='nice -n 19 htop'
#
# I
#
# J
#
# K
#
# L
alias ls='lsd'
alias lsl='lsd -la'
#
# M
alias mv='mv -v'
#
# N
alias nano='nano --linenumbers'
#
# O
#
# P
alias PicomRestart='sh ~/ShellScript/picom-restartRoutine.sh'
#
# Q
#
# R
alias radeontop='nice -n 19 radeontop --color --transparency'
alias reboot='loginctl reboot'
#alias rm='rm -vi'
#
# S
alias set-ondemand='sudo cpupower frequency-set -g ondemand'
alias set-performance='sudo cpupower frequency-set -g performance'
#alias start-ArchBox='sudo rc-service docker start && sudo mount --make-rshared / && sleep 1 && distrobox-enter --root ArchBox' # for OpenRC
alias start-ArchBox='distrobox-enter --root ArchBox' # for systemd 
alias startUpApps='sh ~/ShellScript/startUpApps.sh'
alias syncPortage='sudo emerge-webrsync && sudo emerge --sync && sudo emaint --auto sync'
alias unmskpkg='sh ~/ShellScript/gentoo-unmaskPackage.sh'
#
# T
alias toInstallList='sh ~/ShellScript/toInstallList.sh'
#
# U
alias updatePortage='emerge -pvuND @world'
alias upgradePortage='sudo emerge -avuND @world'
alias upgradeAndInstallPortage='sh ~/ShellScript/gentoo-upgradeAndInstall.sh'
#
# V
alias valiases='bat ~/ShellScript/aliases.sh'
alias valacritty='bat ~/.config/alacritty/alacritty.toml'
alias vawesomeWM='bat ~/.config/awesome/rc.lua'
alias vbash='bat ~/.bashrc'
alias vdistccHost='bat ~/.distcc/hosts'
alias vfstab='bat /etc/fstab'
alias vmake='bat /etc/portage/make.conf'
alias vStartUp='bat ~/ShellScript/startUpApps.sh'
alias vToInstallList='bat ~/ShellScript/gentoo-toInstall.txt'
alias vtmux='bat ~/.dotfiles/.config/tmux/tmux.conf'
alias vumskpkg='bat /etc/portage/package.accept_keywords'
alias vvim='bat ~/.vimrc'
alias vzsh='bat ~/.zshrc'
#
# W
alias watch19='sh ~/ShellScript/watch19.sh'
alias wacomSetStylus='xsetwacom set "Wacom Intuos S Pen stylus" MapToOutput DisplayPort-0'
#
# X
#
# Y
#
# Z
alias zshReset='source ~/.zshrc && sleep 1 && reset'
