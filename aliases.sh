# Alias
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
alias ealias='nvim /home/jkyon/ShellScript/aliases.sh && zreset'
alias ebash='nvim /home/jkyon/.bashrc'
alias efstab='sudo nvim -u ~jkyon/.vimrc /etc/fstab'
alias emake='sudo nvim -u ~jkyon/.vimrc /etc/portage/make.conf'
alias emskpkg='sudo nvim -u ~jkyon/.vimrc /etc/portage/package.accept_keywords'
alias enter-ArchBox='distrobox-enter --root ArchBox'
alias eStartUp='nvim /home/jkyon/ShellScript/startUpApps.sh'
alias eToInstallList='nvim /home/jkyon/ShellScript/gentoo-toInstall.txt'
alias evim='nvim /home/jkyon/.vimrc'
alias ezsh='nvim /home/jkyon/.zshrc'
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
alias startUpApps='sh /home/jkyon/ShellScript/startUpApps.sh'
alias syncPortage='sudo emerge-webrsync && sudo emerge --sync && sudo emaint --auto sync'
alias unmskpkg='sh /home/jkyon/ShellScript/gentoo-unmaskPackage.sh'
#
# T
alias toInstallList='sh /home/jkyon/ShellScript/toInstallList.sh'
#
# U
alias updatePortage='emerge -pvuND @world'
alias upgradePortage='sudo emerge -avuND @world'
alias upgradeAndInstallPortage='sh /home/jkyon/ShellScript/gentoo-upgradeAndInstall.sh'
#
# V
alias valiases='bat /home/jkyon/ShellScript/aliases.sh'
alias vbash='bat /home/jkyon/.bashrc'
alias vfstab='bat /etc/fstab'
alias vmake='bat /etc/portage/make.conf'
alias vStartUp='bat /home/jkyon/ShellScript/startUpApps.sh'
alias vToInstallList='bat /home/jkyon/ShellScript/gentoo-toInstall.txt'
alias vumskpkg='bat /etc/portage/package.accept_keywords'
alias vvim='bat /home/jkyon/.vimrc'
alias vzsh='bat /home/jkyon/.zshrc'
#
# W
alias watch19='sh /home/jkyon/ShellScript/watch19.sh'
#
# Z
alias zreset='source /home/jkyon/.zshrc && sleep 1 && reset'
