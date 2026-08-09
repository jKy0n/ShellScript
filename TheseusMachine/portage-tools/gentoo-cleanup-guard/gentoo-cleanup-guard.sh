#!/usr/bin/env bash
#
#    gentoo-cleanup-guard.sh - Snapshot + restore guard p/ faxina de pacotes
#    Autor: jKyon (com Claudio)
#
# ------------------------------------------------------------------------ #
#    IMPORTANTE: sua / está montada direto em subvolid=5 (ver fstab),
#    não em um subvolume nomeado tipo @. Isso quer dizer que
#    'btrfs subvolume set-default' e 'snapper rollback' NÃO trocam o que
#    é montado como / — o fstab fixa subvolid=5 explicitamente e sempre
#    vence sobre o "default subvolume" do filesystem.
#
#    Por isso este script usa: snapshot RO manual + restore via rsync
#    reverso (sobrescreve / com o conteúdo do snapshot). Funciona
#    independente de layout, de snapper estar configurado, e dá pra
#    rodar de um TTY puro (fora do niri) sem precisar de live-usb,
#    contanto que o sistema ainda dê boot até um shell.
#
#    Uso:
#      sudo ./gentoo-cleanup-guard.sh snapshot ["descrição"]
#      sudo ./gentoo-cleanup-guard.sh list
#      sudo ./gentoo-cleanup-guard.sh restore <caminho-do-snapshot> [--dry-run]
#
#    Pior caso (não dá boot nem até TTY): dê boot pela Ventoy (já tem no
#    fstab) num live ISO qualquer com btrfs-progs + rsync, monte a raiz
#    com 'mount -o subvolid=5 UUID=ca1a25e0-915b-415c-8934-0ca8f7d35f99 /mnt',
#    e rode o mesmo rsync reverso apontando pra /mnt em vez de /.
# ------------------------------------------------------------------------ #

set -euo pipefail

readonly ROOT_UUID="ca1a25e0-915b-415c-8934-0ca8f7d35f99"
readonly SNAP_ROOT="/.snapshots-cleanup"

need_root() {
    [[ $EUID -eq 0 ]] || { echo "ERRO: rode com sudo." >&2; exit 1; }
}

cmd_snapshot() {
    need_root
    local desc="${1:-pre-cleanup-$(date +%Y%m%d-%H%M%S)}"
    local target="${SNAP_ROOT}/${desc}"

    mkdir -p "$SNAP_ROOT"
    echo ">> Criando snapshot RO de / em: ${target}"
    btrfs subvolume snapshot -r / "$target"
    echo ">> OK. Pra restaurar depois:"
    echo "     sudo $0 restore ${target}"
}

cmd_list() {
    need_root
    if [[ -d "$SNAP_ROOT" ]] && [[ -n "$(ls -A "$SNAP_ROOT" 2>/dev/null)" ]]; then
        echo "Snapshots em ${SNAP_ROOT}:"
        for d in "$SNAP_ROOT"/*/; do
            printf '  %s\n' "${d%/}"
        done
    else
        echo "Nenhum snapshot ainda. Rode: $0 snapshot"
    fi
}

cmd_restore() {
    need_root
    local snap="" dry=false

    for arg in "$@"; do
        case "$arg" in
            --dry-run) dry=true ;;
            *) snap="$arg" ;;
        esac
    done

    [[ -n "$snap" && -d "$snap" ]] || {
        echo "ERRO: informe um snapshot válido (veja: $0 list)." >&2
        exit 1
    }

    # -a: arquivo completo (perms, dono, symlinks, timestamps)
    # -A -X: ACLs + xattrs (importante p/ capabilities de binários)
    # -H: preserva hardlinks
    # -x: NÃO cruza fronteira de filesystem/subvolume — pula automaticamente
    #     /boot, /efi, /home, /mnt/* (são mounts/subvolumes separados) e
    #     também pula o próprio SNAP_ROOT (subvolume aninhado tem dev_t
    #     próprio no btrfs)
    # --delete: remove da / o que não existe no snapshot (ex: pacotes
    #     instalados DEPOIS do snapshot)
    local rsync_opts=(-aAXHx --delete --exclude="${SNAP_ROOT#/}/")
    if $dry; then
        rsync_opts+=(--dry-run -v)
    else
        echo "!! Isso vai sobrescrever / com o conteúdo de: ${snap}"
        echo "!! Rode de um TTY puro (Ctrl+Alt+F3, fora do niri/SDDM)."
        read -rp "Digite 'sim' pra confirmar: " confirm
        [[ "$confirm" == "sim" ]] || { echo "Abortado."; exit 1; }
    fi

    rsync "${rsync_opts[@]}" "${snap}/" /

    $dry || echo ">> Restaurado. Reinicie agora: systemctl reboot"
}

main() {
    case "${1:-}" in
        snapshot) shift; cmd_snapshot "$@" ;;
        list)     cmd_list ;;
        restore)  shift; cmd_restore "$@" ;;
        *)
            echo "Uso: $0 {snapshot [desc]|list|restore <dir> [--dry-run]}" >&2
            exit 1
            ;;
    esac
}

main "$@"