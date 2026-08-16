#!/bin/bash
BACKUP_DIR="$HOME/.gpgKeys.bak"

# Criar o diretório se não existir
mkdir -p "$BACKUP_DIR"

# Exportar as chaves
gpg --export --armor > "$BACKUP_DIR/gpg-keys-public.asc"
gpg --export-secret-keys --armor > "$BACKUP_DIR/gpg-keys-private.asc"

# Compactar e criptografar
tar -czf - "$BACKUP_DIR/gpg-keys-*.asc" | gpg --encrypt --recipient "SEU_EMAIL" -o "$BACKUP_DIR/gpg-backup.tar.gz.gpg"

# Limpar arquivos temporários
rm -f "$BACKUP_DIR/gpg-keys-*.asc"
