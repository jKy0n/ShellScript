#!/bin/bash
#
#        Title:      incubadora.sh
#        Brief:      Entra numa incubadora de binpkgs do Builder (systemd-nspawn) ou roda um comando nela.
#        Path:       /home/jkyon/ShellScript/Builder/Scripts/incubadora/incubadora.sh
#        Author:     John Kennedy a.k.a. jKyon
#        Created:    2026-10-29
#        Updated:    2026-10-29
#        Notes:
#          Uso (como root):
#            incubadora.sh viamar-pc                      -> shell na incubadora
#            incubadora.sh viamar-pc emerge -uDN @world   -> roda o comando
#
#          Cada máquina-alvo tem o seu chroot em /var/lib/incubator/<alvo>
#          (ver machines/builder/builder.md, "Incubadora de binpkgs").
#          Os repos gentoo, guru e jkyon-overlay vêm do host, só-leitura (o host
#          sincroniza; o gentoo é o mirror do parque). Os overlays restritos
#          (CachyOS-kernels, parona, xarblu) vivem só dentro do chroot.
#
#          /run/lock: o /run do nspawn começa vazio, e sem esse diretório a
#          assinatura dos binpkgs falha (flock em /run/lock/portage-binpkg-gpg.lock).
#
#          O nspawn só abre uma instância por chroot: com um emerge rodando
#          (ex.: numa unit systemd-run), espere ele terminar.
#

set -euo pipefail

BASE="/var/lib/incubator"

if [[ $EUID -ne 0 ]]; then
    echo "Precisa de root: sudo $(basename "$0") $*" >&2
    exit 1
fi

TARGET="${1:-}"
if [[ -z "$TARGET" ]]; then
    echo "Uso: $(basename "$0") <alvo> [comando...]" >&2
    echo "Alvos: $(ls "$BASE" | tr '\n' ' ')" >&2
    exit 1
fi
shift

ROOT="$BASE/$TARGET"
if [[ ! -d "$ROOT/etc/portage" ]]; then
    echo "Incubadora não encontrada: $ROOT" >&2
    echo "Alvos: $(ls "$BASE" | tr '\n' ' ')" >&2
    exit 1
fi

BINDS=()
for repo in gentoo guru jkyon-overlay; do
    BINDS+=("--bind-ro=/var/db/repos/$repo")
done

if [[ $# -eq 0 ]]; then
    set -- /bin/bash -l
fi

exec systemd-nspawn -q -D "$ROOT" "${BINDS[@]}" \
    /bin/sh -c 'mkdir -p /run/lock && exec "$@"' sh "$@"
