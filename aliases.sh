# Alias
#
#   Exemplo de como usar um comando coringa entre sudo e doas
#     Não recomendado pelas boas práticas com aliases
#
#export AUTH_CMD=$(command -v sudo || command -v doas)
#
# set-performance() {
#     $AUTH_CMD cpupower frequency-set -g performance
# }
#
# set-ondemand() {
#     $AUTH_CMD cpupower frequency-set -g ondemand
# }
#
#
#alias tmux='tmux new-session source-file /home/jkyon/.dotfiles/.config/tmux.conf'
#alias tmux='tmux'
#
# A
alias breset='source /home/jkyon/.bashrc && sleep 1 && reset'
alias btop='nice -n 19 btop'
#
# C
alias clr='clear'
alias cp='cp  -v'
alias cupsStart='sudo rc-service cupsd start'
alias cupsStop='sudo rc-service cupsd stop'
#
# E
alias ealias='nano --linenumbers /home/jkyon/ShellScript/aliases.sh && zreset'
alias ebash='nano --linenumbers /home/jkyon/.bashrc'
alias efstab='sudo nano --linenumbers /etc/fstab'
alias emake='sudo nano --linenumbers /etc/portage/make.conf'
alias emskpkg='sudo nano --linenumbers /etc/portage/package.accept_keywords'
alias enter-ArchBox='distrobox-enter --root ArchBox'
alias eStartUp='nano --linenumbers /home/jkyon/ShellScript/startUpApps.sh'
alias ezsh='nano --linenumbers /home/jkyon/.zshrc'
#
# F
alias ffetch='fastfetch'
#
# G
alias grep='grep --colour=auto'
#
# H
alias helptty='sudo fbset -xres 3440 -yres 1440 && sh /home/jkyon/ShellScript/tmux-quickstart.sh'
alias htop='nice -n 19 htop'
#
# L
alias ls='ls --color'
alias lsl='ls -laZ --color'
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
alias start-ArchBox='sudo rc-service docker start && sudo mount --make-rshared / &&  distrobox-enter --root ArchBox'
alias startUpApps='sh /home/jkyon/ShellScript/startUpApps.sh'
alias syncPortage='sudo emerge-webrsync && sudo emerge --sync && sudo emaint --auto sync'
alias unmskpkg='sh /home/jkyon/ShellScript/gentoo-unmaskPackage.sh'
#
# U
alias updatePortage='emerge -pvuND @world'
alias upgradePortage='sudo emerge -avuND @world'
#
# V
alias valiases='bat /home/jkyon/ShellScript/aliases.sh'
alias vbash='bat /home/jkyon/.bashrc'
alias vfstab='bat /etc/fstab'
alias vmake='bat /etc/portage/make.conf'
alias vStartUp='bat /home/jkyon/ShellScript/startUpApps.sh'
alias vumskpkg='bat /etc/portage/package.accept_keywords'
alias vzsh='bat /home/jkyon/.zshrc'
#
# Z
alias zreset='source /home/jkyon/.zshrc && sleep 1 && reset'
