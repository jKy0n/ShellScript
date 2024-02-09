# Alias

#   Exemplo de como usar um comando coringa entre sudo e doas
#     Não recomendado pelas boas práticas com aliases
#
#export AUTH_CMD=$(command -v doas || command -v sudo)
#
# set-performance() {
#     $AUTH_CMD cpupower frequency-set -g performance
# }
#
# set-ondemand() {
#     $AUTH_CMD cpupower frequency-set -g ondemand
# }


alias cp='cp  -v'
alias grep='grep --colour=auto'
alias ls='ls --color'
alias mv='mv -v'
alias nano='nano --linenumbers'

#alias tmux='tmux new-session source-file /home/jkyon/.dotfiles/.config/tmux.conf'
#alias tmux='tmux'


alias ffetch='fastfetch'

alias htop='nice -n 19 htop'
alias btop='nice -n 19 btop'
alias radeontop='nice -n 19 radeontop --color --transparency'

alias set-performance='doas cpupower frequency-set -g performance'
alias set-ondemand='doas cpupower frequency-set -g ondemand'

alias start-darch='doas rc-service docker start && doas mount --make-rshared / &&  distrobox-enter --root archlinux'
alias enter-darch='distrobox-enter --root archlinux'

# alias pkguse='/etc/portage/package.use'
# alias mskpkg='/etc/portage/package.accept_keywords'

alias show-aliases='bat /home/jkyon/ShellScript/aliases.sh'
alias ealias='nano --linenumbers /home/jkyon/ShellScript/aliases.sh'
alias ealiasr='nano --linenumbers /home/jkyon/ShellScript/aliases.sh && zreset && clear'

alias eStartUp='nano --linenumbers /home/jkyon/ShellScript/startUpApps.sh'
alias startUpApps='sh /home/jkyon/ShellScript/startUpApps.sh'

alias vmake='bat /etc/portage/make.conf'

alias esync='doas emerge-webrsync && doas emerge --sync && doas emaint --auto sync'
alias emake='doas nano --linenumbers /etc/portage/make.conf'
alias emskpkg='doas nano --linenumbers /etc/portage/package.accept_keywords'
#alias epkguse='doas nano --linenumbers /etc/portage/package.use/$1'
alias efstab='doas nano --linenumbers /etc/fstab'
alias ezsh='nano --linenumbers /home/jkyon/.zshrc'
alias ebash='nano --linenumbers /home/jkyon/.bashrc'

alias clr='clear'
alias breset='source /home/jkyon/.bashrc && sleep 1 && reset'
alias zreset='source /home/jkyon/.zshrc && sleep 1 && reset'

alias helptty='doas fbset -xres 3440 -yres 1440 && sh /home/jkyon/ShellScript/tmux-quickstart.sh'
alias reboot='loginctl reboot'


alias unmskpkg='sh ~/ShellScript/gentoo-unmaskPackage.sh'
