#!/bin/bash
#
#        Title:      rambox-update.sh
#        Brief:      Atualiza o Rambox a partir de um AppImage novo (versão extraída, sem FUSE).
#        Path:       /home/jkyon/ShellScript/Viamar-PC/Scripts/rambox-update/rambox-update.sh
#        Author:     John Kennedy a.k.a. jKyon
#        Created:    2026-10-29
#        Updated:    2026-10-29
#        Notes:
#          Uso: rambox-update.sh ~/Downloads/Rambox-X.Y.Z-linux-x64.AppImage
#
#          O Rambox roda EXTRAÍDO (não montado via FUSE): AppImage montado
#          travava a suspensão (o kernel congela o processo do FUSE antes do
#          Rambox, que fica preso em estado D lendo o próprio AppImage).
#
#          Layout em ~/Apps/appimage/rambox/:
#            Rambox-X.Y.Z-linux-x64.AppImage   download original
#            Rambox-X.Y.Z/                     extraído (--appimage-extract)
#            current -> Rambox-X.Y.Z           versão em uso
#
#          O próprio Rambox reescreve ~/.local/share/applications/rambox.desktop
#          a cada start, com o caminho real do binário. Por isso o script fecha
#          o antigo e abre o novo pelo `current`: é esse start que aponta o
#          atalho do launcher pra versão nova.
#
#          As versões antigas ficam na pasta (rollback = apontar o `current` de
#          volta e abrir pelo current/AppRun). Apagar à mão quando quiser.
#

set -euo pipefail

DIR="$HOME/Apps/appimage/rambox"

APPIMAGE="${1:-}"
if [[ -z "$APPIMAGE" || ! -f "$APPIMAGE" ]]; then
    echo "Uso: $(basename "$0") <Rambox-X.Y.Z-linux-x64.AppImage>" >&2
    exit 1
fi

NAME="$(basename "$APPIMAGE")"
VERSION="$(sed -nE 's/^Rambox-([0-9][0-9.]*)-linux-x64\.AppImage$/\1/p' <<<"$NAME")"
if [[ -z "$VERSION" ]]; then
    echo "Nome inesperado: $NAME (esperado Rambox-X.Y.Z-linux-x64.AppImage)" >&2
    exit 1
fi

TARGET="$DIR/Rambox-$VERSION"
if [[ -e "$TARGET" ]]; then
    echo "Já existe: $TARGET (versão $VERSION já extraída)" >&2
    exit 1
fi

# AppImage dentro da pasta do Rambox (se veio de outro lugar, move pra cá)
if [[ "$(realpath "$APPIMAGE")" != "$DIR/$NAME" ]]; then
    mv -v "$APPIMAGE" "$DIR/$NAME"
fi
chmod u+x "$DIR/$NAME"

# extrai num diretório temporário dentro da própria pasta (mesmo filesystem, mv atômico)
TMP="$(mktemp -d "$DIR/.extract-XXXXXX")"
trap 'rm -rf "$TMP"' EXIT
( cd "$TMP" && "$DIR/$NAME" --appimage-extract >/dev/null )
mv "$TMP/squashfs-root" "$TARGET"
echo "Extraído: $TARGET"

PREV="$(readlink "$DIR/current" 2>/dev/null || echo "nenhuma")"
ln -sfn "Rambox-$VERSION" "$DIR/current"
echo "current: $PREV -> Rambox-$VERSION"

# fecha o Rambox em uso (SIGTERM pra ele salvar o estado) e abre o novo
if pgrep -x rambox.bin >/dev/null; then
    pkill -TERM -x rambox.bin
    for _ in $(seq 1 20); do
        pgrep -x rambox.bin >/dev/null || break
        sleep 1
    done
    if pgrep -x rambox.bin >/dev/null; then
        echo "O Rambox não fechou em 20s. Feche à mão e rode: $DIR/current/AppRun --no-sandbox" >&2
        exit 1
    fi
fi

setsid -f "$DIR/current/AppRun" --no-sandbox >/dev/null 2>&1
echo "Rambox $VERSION aberto. O atalho do launcher é regravado por ele neste start."
