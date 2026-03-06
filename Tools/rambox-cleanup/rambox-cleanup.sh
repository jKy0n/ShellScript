#!/bin/bash

echo "🧹 Iniciando limpeza do Rambox..."

# 1. Fecha o Rambox
echo "1. Fechando Rambox..."
killall -9 rambox 2>/dev/null
sleep 2

# 2. Faz backup
echo "2. Fazendo backup..."
tar -czf ~/Rambox_backup_$(date +%Y%m%d_%H%M%S).tar.gz ~/.config/Rambox/ 2>/dev/null

# 3. Limpa cache
echo "3. Limpando cache..."
rm -rf ~/.cache/Rambox/
rm -rf ~/.config/Rambox/Cache/
rm -rf ~/.config/Rambox/Code\ Cache/
rm -rf ~/.config/Rambox/Session\ Storage/
rm -rf ~/.config/Rambox/logs/

# 4. Limpa banco de dados
echo "4. Reconstruindo banco de dados..."
rm -f ~/.config/Rambox/*.db
rm -f ~/.config/Rambox/*.db-journal

# 5. Mostra espaço economizado
echo "5. Verificando espaço..."
du -sh ~/.config/Rambox/
du -sh ~/.cache/Rambox/ 2>/dev/null || echo "Cache removido com sucesso"

echo "✅ Limpeza concluída!"
  echo "💡 Abra o Rambox normalmente. Suas contas estarão intactas."
