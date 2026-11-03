#!/bin/bash
#
#        Title:      incubadora.sh
#        Brief:      Entra numa incubadora de binpkgs do Builder (systemd-nspawn) ou roda um comando nela.
#        Path:       /home/jkyon/ShellScript/Builder/Scripts/incubadora/incubadora.sh
#        Author:     John Kennedy a.k.a. jKyon
#        Created:    2026-10-29
#        Updated:    2026-11-03
#        Notes:
#          Compilação quieta por padrão (--quiet-build=y no make.conf do chroot);
#          "--verbose" por extenso no emerge traz a saída de volta.
#
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
# Mirrors do host (mirrorselect-update.timer); o chroot tem um mirrors.list
# próprio só com comentário, pro make.conf carregar sem o bind (incubadora-eclean)
if [[ -f /etc/portage/mirrors.list ]]; then
    BINDS+=("--bind-ro=/etc/portage/mirrors.list")
fi

if [[ $# -eq 0 ]]; then
    set -- /bin/bash -l
fi

# A compilação é quieta por padrão (--quiet-build=y no EMERGE_DEFAULT_OPTS do
# chroot); "--verbose" escrito por extenso traz a saída de volta. O -v de -av/-pv
# segue só detalhando a lista de pacotes.
if [[ $1 == emerge ]]; then
    for arg in "$@"; do
        if [[ $arg == --verbose ]]; then
            set -- "$@" --quiet-build=n
            break
        fi
    done
fi

# Famílias de socket sem restrição, explícito (o padrão de hoje): o systemd 261
# avisa que o padrão futuro vai ser só AF_INET/AF_INET6/AF_UNIX, e build às vezes
# usa outras (AF_NETLINK pra listar interfaces, por exemplo).
exec systemd-nspawn -q -D "$ROOT" --restrict-address-families= "${BINDS[@]}" \
    /bin/sh -c 'mkdir -p /run/lock && exec "$@"' sh "$@"
