#!/usr/bin/env bash

OLD_PREFIX="/old/path"
NEW_PREFIX="/new/path"

while IFS= read -r link; do
  # Guarda o destino antigo:
  old_target="$(readlink "$link")"

  # Verifica se ele começa com OLD_PREFIX:
  if [[ "$old_target" == "$OLD_PREFIX"* ]]; then
    # Constrói o novo destino ajustando o prefixo:
    # Ex.: /new/path + (old_target sem /old/path no início)
    new_target="$NEW_PREFIX${old_target#$OLD_PREFIX}"

    # Cria o novo link simbólico forçando (-sf).
    echo "Corrigindo $link : $old_target -> $new_target"
    ln -snf "$new_target" "$link"
  fi
done < /tmp/links_quebrados.txt
