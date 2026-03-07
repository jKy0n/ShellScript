#
#        Title:      rambox-cleanup.sh
#        Brief:      Just a simple script to clean up Rambox data on TheseusMachine.
#        Path:       ~/ShellScript/TheseusMachine/tools/rambox-cleanup.sh
#        Author:     John Kennedy a.k.a. jKyon
#        Created:    2026-03-07
#        Updated:    2026-03-07
#        Notes:      No notes yet
#
#

#!/bin/bash

echo "🧹 Iniciando limpeza do Rambox na TheseusMachine..."

# 1. Fecha o Rambox
killall -9 rambox 2>/dev/null
sleep 2

# 2. Faz backup
tar -czf ~/Rambox_backup_$(date +%Y%m%d_%H%M%S).tar.gz ~/.config/rambox/ 2>/dev/null

# 3. Limpa cache (ATENÇÃO: usar 'rambox' minúsculo)
rm -rf ~/.cache/rambox/
rm -rf ~/.config/rambox/Cache/
rm -rf ~/.config/rambox/Code\ Cache/
rm -rf ~/.config/rambox/Session\ Storage/
rm -rf ~/.config/rambox/logs/

# 4. Limpa banco de dados
rm -f ~/.config/rambox/*.db
rm -f ~/.config/rambox/*.db-journal

echo "✅ Limpeza concluída!"