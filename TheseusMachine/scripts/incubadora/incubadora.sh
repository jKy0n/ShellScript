#!/bin/bash
#
#        Title:      incubadora.sh
#        Brief:      Entra numa incubadora de binpkgs da TheseusMachine (systemd-nspawn) ou roda um comando nela.
#        Path:       /home/jkyon/ShellScript/TheseusMachine/scripts/incubadora/incubadora.sh
#        Author:     John Kennedy a.k.a. jKyon
#        Created:    2026-10-29
#        Updated:    2026-11-13
#        Notes:
#          Compilação quieta por padrão (--quiet-build=y no make.conf do chroot);
#          "--verbose" por extenso no emerge traz a saída de volta.
#
#          Uso (como root):
#            incubadora.sh viamar-pc                      -> shell na incubadora
#            incubadora.sh viamar-pc emerge -uDN @world   -> roda o comando
#            incubadora.sh viamar-pc update               -> emerge -pvuDN @world
#            incubadora.sh viamar-pc upgrade              -> emerge -avuDN @world
#          Argumentos depois de update/upgrade vão pro emerge
#          (ex.: upgrade --exclude=mail-client/thunderbird).
#
#          Cada máquina-alvo tem o seu chroot em /mnt/incubadora/<alvo>, um
#          subvolume do volume incubatorium (ver machines/theseusmachine/
#          theseusmachine.md, "Incubatorium"). Até 2026-11-13 ficava no Builder.
#          De outras máquinas, a função zsh "incubadora" chega aqui por SSH.
#
#          Fora do chroot, em bind:
#            /mnt/incubadora/distfiles           -> /var/cache/distfiles
#              (compartilhado entre os alvos)
#            /var/tmp/portage-incubadora/<alvo>  -> /var/tmp/portage
#              (no root, fora do incubatorium: o bees não perde tempo com
#              temporário de build)
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

BASE="/mnt/incubadora"
TMPBASE="/var/tmp/portage-incubadora"

if [[ $EUID -ne 0 ]]; then
    echo "Precisa de root: sudo $(basename "$0") $*" >&2
    exit 1
fi

# Alvo = subvolume com /etc/portage (o distfiles compartilhado fica de fora).
alvos() {
    local d
    for d in "$BASE"/*/; do
        [[ -d "$d/etc/portage" ]] && printf '%s ' "$(basename "$d")"
    done
}

TARGET="${1:-}"
if [[ -z "$TARGET" ]]; then
    echo "Uso: $(basename "$0") <alvo> [comando...]" >&2
    echo "Alvos: $(alvos)" >&2
    exit 1
fi
shift

ROOT="$BASE/$TARGET"
if [[ ! -d "$ROOT/etc/portage" ]]; then
    echo "Incubadora não encontrada: $ROOT" >&2
    echo "Alvos: $(alvos)" >&2
    exit 1
fi

BINDS=()
install -d -o portage -g portage -m 0775 "$TMPBASE/$TARGET"
BINDS+=("--bind=$BASE/distfiles:/var/cache/distfiles")
BINDS+=("--bind=$TMPBASE/$TARGET:/var/tmp/portage")
for repo in gentoo guru jkyon-overlay; do
    BINDS+=("--bind-ro=/var/db/repos/$repo")
done
# Mirrors do host (mirrorselect-update.timer); o chroot tem um mirrors.list
# próprio só com comentário, pro make.conf carregar sem o bind (incubadora-eclean)
if [[ -f /etc/portage/mirrors.list ]]; then
    BINDS+=("--bind-ro=/etc/portage/mirrors.list")
fi

case "${1:-}" in
    update)  shift; set -- emerge -pvuDN @world "$@" ;;
    upgrade) shift; set -- emerge -avuDN @world "$@" ;;
esac

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
