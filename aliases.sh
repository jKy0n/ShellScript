# Alias
#
#
#alias tmux='tmux new-session source-file ~/.dotfiles/.config/tmux.conf'
#alias tmux='tmux'
#
# A
alias breset='source ~/.bashrc && sleep 1 && reset'
alias btop='nice -n 19 btop'
#
# C
alias clr='clear'
alias cp='cp  -v'
alias cupsStart='sudo rc-service cupsd start'
alias cupsStop='sudo rc-service cupsd stop'
#
# E
alias ealias='nvim ~/ShellScript/aliases.sh && zreset'
alias ebash='nvim ~/.bashrc'
alias efstab='sudo nvim -u ~jkyon/.vimrc /etc/fstab'
alias emake='sudo nvim -u ~jkyon/.vimrc /etc/portage/make.conf'
alias emskpkg='sudo nvim -u ~jkyon/.vimrc /etc/portage/package.accept_keywords'
alias enter-ArchBox='distrobox-enter --root ArchBox'
alias eStartUp='nvim ~/ShellScript/startUpApps.sh'
alias eToInstallList='nvim ~/ShellScript/gentoo-toInstall.txt'
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
# L
alias ls='ls --color'
alias lsl='ls -la --color'
#
# M
alias mv='mv -v'
#
# N
alias nano='nano --linenumbers'
#
# R
alias radeontop='nice -n 19 radeontop --color --transparency'
alias reboot='loginctl reboot'
#
# S
alias set-ondemand='sudo cpupower frequency-set -g ondemand'
alias set-performance='sudo cpupower frequency-set -g performance'
alias start-ArchBox='sudo rc-service docker start && sudo mount --make-rshared / && sleep 1 && distrobox-enter --root ArchBox'
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
alias vbash='bat ~/.bashrc'
alias vfstab='bat /etc/fstab'
alias vmake='bat /etc/portage/make.conf'
alias vStartUp='bat ~/ShellScript/startUpApps.sh'
alias vToInstallList='bat ~/ShellScript/gentoo-toInstall.txt'
alias vumskpkg='bat /etc/portage/package.accept_keywords'
alias vvim='bat ~/.vimrc'
alias vzsh='bat ~/.zshrc'
#
# W
alias watch19='sh ~/ShellScript/watch19.sh'
#
# Z
alias zreset='source ~/.zshrc && sleep 1 && reset'
