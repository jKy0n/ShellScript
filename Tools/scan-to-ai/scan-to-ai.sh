#!/usr/bin/env bash
#
#        Title:      scan-to-ai.sh
#        Brief:      Gera um snapshot em Markdown do estado atual da máquina Linux.
#        Path:       /home/jkyon/ShellScript/Tools/scan-to-ai/scan-to-ai.sh
#        Author:     John Kennedy a.k.a. jKyon
#        Created:    2026-07-26
#        Updated:    2026-07-26
#        Notes:
#                    Um único "gerador" (generate_report) alimenta dois destinos:
#                      - Tela, em modo humano, renderizado pelo glow (se instalado)
#                      - Clipboard / arquivo, em modo AI (Markdown puro, pronto pra colar num chat)
#
#                    Uso: veja show_help() abaixo, ou rode: scan-to-ai --help
#                    -----------------------------------------------------------------------------
#
#                    COMO ADICIONAR UMA NOVA SEÇÃO (guia rápido pra manutenção):
#                      1. Copie uma função sec_* existente como modelo.
#                      2. Ajuste o título "## N. Título" e os comandos dentro do bloco.
#                      3. Chame a nova função dentro de generate_report(), na ordem desejada.
#                      4. Todo comando que pode não existir na máquina deve ter fallback
#                         (ex: "if command_exists foo; then foo; else echo '(foo não instalado)'; fi")
#                         pra o script nunca travar ou poluir a saída com erro cru.
#                    -----------------------------------------------------------------------------

set -uo pipefail

SCRIPT_NAME="scan-to-ai"
SCRIPT_VERSION="1.0.0"

# =============================================================================
# HELPERS
# =============================================================================

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Envolve o que vier do stdin num bloco de código Markdown.
# Uso: { comando1; comando2; } | code_block
code_block() {
    echo '```'
    cat
    echo '```'
}

# Copia texto para a área de transferência, detectando X11 ou Wayland.
copy_to_clipboard() {
    local content="$1"
    if [ "${XDG_SESSION_TYPE:-}" = "wayland" ] && command_exists wl-copy; then
        printf '%s' "$content" | wl-copy
    elif command_exists xclip; then
        printf '%s' "$content" | xclip -selection clipboard -in
    else
        echo "⚠️  Nenhuma ferramenta de clipboard encontrada (instale xclip ou wl-clipboard)." >&2
        return 1
    fi
}

# Renderiza o conteúdo no modo pedido.
# mode="human": passa pelo glow (se instalado). O próprio glow detecta
#               sozinho se a saída é terminal ou não, e ajusta o estilo
#               (colorido no terminal, texto limpo se redirecionado a um arquivo).
# mode="ai":    Markdown puro, sem processamento.
render_content() {
    local content="$1"
    local mode="$2"

    if [ "$mode" = "human" ] && command_exists glow; then
        printf '%s' "$content" | glow -
    else
        printf '%s\n' "$content"
    fi
}

# -----------------------------------------------------------------------------
# Filtro de ruído em logs (journalctl)
# -----------------------------------------------------------------------------
# Alguns eventos (ex: erros de hardware MCE, bloqueios de firewall) podem se
# repetir milhares de vezes no journal e afogar o diagnóstico. Em vez de
# despejar tudo, quando um padrão passa de NOISE_THRESHOLD ocorrências,
# o filtro substitui todas as linhas dele por um aviso + comando pra
# investigar manualmente quando necessário.
#
# COMO ADICIONAR UM NOVO PADRÃO: acrescente um item em cada um dos 3 arrays
# abaixo (mesma posição/índice nos três).
NOISE_THRESHOLD=100

NOISE_REGEX=(
    'mce: \[Hardware Error\]'
    '\[UFW BLOCK\]'
)
NOISE_LABEL=(
    'Erros de hardware (MCE)'
    'Bloqueios de firewall (UFW)'
)
NOISE_CMD=(
    'journalctl -k -b -g "Hardware Error" --no-pager'
    'journalctl -k -b -g "UFW BLOCK" --no-pager'
)

# Uso: journalctl ... | filter_noise
filter_noise() {
    local input
    input="$(cat)"

    local i regex label cmd count
    for i in "${!NOISE_REGEX[@]}"; do
        regex="${NOISE_REGEX[$i]}"
        label="${NOISE_LABEL[$i]}"
        cmd="${NOISE_CMD[$i]}"

        count="$(grep -cE "$regex" <<< "$input" || true)"

        if [ "$count" -gt "$NOISE_THRESHOLD" ]; then
            input="$(grep -vE "$regex" <<< "$input" || true)"
            input="${input}
[filtro] ⚠ ${label}: ${count} ocorrências suprimidas (> ${NOISE_THRESHOLD} linhas).
         Para investigar: ${cmd}"
        fi
    done

    printf '%s\n' "$input"
}

# =============================================================================
# SEÇÕES DO RELATÓRIO
# =============================================================================

sec_sistema() {
    echo "## 1. Sistema"
    echo
    {
        hostnamectl 2>&1
        echo
        uname -a
        echo
        cat /etc/os-release
        echo
        uptime
    } | code_block
    echo
}

sec_cpu() {
    echo "## 2. CPU"
    echo
    {
        lscpu
        echo
        echo "--- Driver de frequência ---"
        cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_driver 2>/dev/null | sort -u
        echo
        echo "--- Governor ---"
        cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor 2>/dev/null | sort -u
        echo
        echo "--- Intel P-State ---"
        cat /sys/devices/system/cpu/intel_pstate/status 2>/dev/null
        cat /sys/devices/system/cpu/intel_pstate/no_turbo 2>/dev/null
        echo
        echo "--- cpupower ---"
        if command_exists cpupower; then
            cpupower frequency-info 2>&1
        else
            echo "(cpupower não instalado)"
        fi
    } | code_block
    echo
}

sec_memoria() {
    echo "## 3. Memória / Swap / ZRAM"
    echo
    {
        free -h
        echo
        swapon --show
        echo
        if command_exists zramctl; then zramctl; fi
        echo
        cat /proc/swaps
        echo
        echo "--- ZRAM: algoritmo de compressão ---"
        cat /sys/block/zram0/comp_algorithm 2>/dev/null
        echo
        echo "--- ZRAM: tamanho do disco ---"
        cat /sys/block/zram0/disksize 2>/dev/null
    } | code_block
    echo
}

sec_armazenamento() {
    echo "## 4. Armazenamento"
    echo
    {
        lsblk -o NAME,MODEL,SERIAL,SIZE,TYPE,FSTYPE,FSVER,LABEL,UUID,MOUNTPOINTS
        echo
        df -hT
        echo
        findmnt
        echo
        echo "--- BTRFS: filesystem show ---"
        sudo btrfs filesystem show 2>/dev/null
        echo
        echo "--- BTRFS: filesystem usage ---"
        sudo btrfs filesystem usage / 2>/dev/null
        echo
        echo "--- BTRFS: subvolumes ---"
        sudo btrfs subvolume list / 2>/dev/null
    } | code_block
    echo
}

sec_armazenamento_saude() {
    echo "## 5. Saúde de Armazenamento"
    echo
    {
        echo "--- SMART (smartmontools) ---"
        if command_exists smartctl; then
            for dev in /dev/sd? /dev/nvme?n1; do
                [ -e "$dev" ] || continue
                echo "=== $dev ==="
                sudo smartctl -H -A "$dev" 2>&1
                echo
            done
        else
            echo "(smartctl não instalado — pacote smartmontools)"
        fi
        echo
        echo "--- fstrim.timer ---"
        systemctl status fstrim.timer --no-pager 2>&1
        echo
        echo "--- I/O scheduler por disco ---"
        for q in /sys/block/*/queue/scheduler; do
            [ -f "$q" ] || continue
            echo "$q: $(cat "$q")"
        done
        echo
        echo "--- Arquivos .pacnew pendentes ---"
        find /etc -name "*.pacnew" 2>/dev/null
        echo
        echo "--- Cache do pacman ---"
        du -sh /var/cache/pacman/pkg 2>/dev/null
    } | code_block
    echo
}

sec_gpu() {
    echo "## 6. GPU / PCI / Drivers"
    echo
    {
        lspci -nnk
        echo
        echo "--- VGA / 3D / Display ---"
        lspci -nnk | grep -A3 -E 'VGA|3D|Display'
        echo
        echo "--- Hardware de rede ---"
        lspci -nnk | grep -A3 -E 'Ethernet|Network'
    } | code_block
    echo
}

sec_opengl() {
    echo "## 7. OpenGL / Vulkan / VA-API"
    echo
    {
        echo "--- OpenGL ---"
        if command_exists glxinfo; then glxinfo -B 2>&1; else echo "(glxinfo não instalado)"; fi
        echo
        echo "--- Vulkan ---"
        if command_exists vulkaninfo; then vulkaninfo --summary 2>&1; else echo "(vulkaninfo não instalado)"; fi
        echo
        echo "--- VA-API ---"
        if command_exists vainfo; then vainfo 2>&1; else echo "(vainfo não instalado)"; fi
    } | code_block
    echo
}

sec_temperaturas() {
    echo "## 8. Temperaturas / Sensores"
    echo
    {
        if command_exists sensors; then sensors 2>&1; else echo "(lm_sensors não instalado)"; fi
        echo
        echo "--- Zonas térmicas ---"
        for z in /sys/class/thermal/thermal_zone*; do
            [ -d "$z" ] || continue
            echo "=== $z ==="
            cat "$z/type" 2>/dev/null
            cat "$z/temp" 2>/dev/null
        done
    } | code_block
    echo
}

sec_bateria() {
    echo "## 9. Bateria / Energia"
    echo
    {
        echo "--- Fontes de energia ---"
        ls -l /sys/class/power_supply/ 2>/dev/null
        echo
        echo "--- UPower ---"
        if command_exists upower; then upower -e 2>&1; else echo "(upower não instalado)"; fi
        echo
        echo "--- Detalhes de bateria ---"
        for bat in /sys/class/power_supply/BAT*; do
            [ -d "$bat" ] || continue
            echo "=== $bat ==="
            for f in status capacity health cycle_count energy_full energy_full_design charge_full charge_full_design; do
                [ -f "$bat/$f" ] && printf '%-22s: %s\n' "$f" "$(cat "$bat/$f")"
            done
        done
        echo
        echo "--- Perfis de energia ---"
        if command_exists powerprofilesctl; then powerprofilesctl 2>&1; else echo "(powerprofilesctl não instalado)"; fi
        echo
        echo "--- TLP ---"
        if command_exists tlp-stat; then tlp-stat -b 2>&1; else echo "(TLP não instalado)"; fi
    } | code_block
    echo
}

sec_display() {
    echo "## 10. Display / Sessão Gráfica"
    echo
    {
        echo "--- Tipo de sessão ---"
        echo "XDG_SESSION_TYPE: ${XDG_SESSION_TYPE:-desconhecido}"
        echo "DISPLAY: ${DISPLAY:-não definido}"
        echo
        if [ "${XDG_SESSION_TYPE:-}" = "wayland" ]; then
            echo "--- Sessão Wayland detectada ---"
            echo "(xrandr não se aplica; use wlr-randr/hyprctl conforme o compositor)"
        else
            echo "--- XRandR ---"
            if command_exists xrandr; then xrandr --query 2>&1; else echo "(xrandr não disponível)"; fi
            echo
            echo "--- Monitores ---"
            if command_exists xrandr; then xrandr --listmonitors 2>&1; fi
        fi
        echo
        echo "--- Sessões de login ---"
        loginctl 2>&1
    } | code_block
    echo
}

sec_input() {
    echo "## 11. Input / Touchpad"
    echo
    {
        echo "--- libinput ---"
        if command_exists libinput; then sudo libinput list-devices 2>&1; else echo "(libinput não disponível)"; fi
        echo
        echo "--- xinput ---"
        if command_exists xinput; then xinput list 2>&1; else echo "(xinput não disponível)"; fi
        echo
        echo "--- Configuração libinput no Xorg ---"
        grep -R "libinput" /etc/X11/xorg.conf.d/ 2>/dev/null
    } | code_block
    echo
}

sec_rede() {
    echo "## 12. Rede"
    echo
    {
        ip addr
        echo
        ip route
        echo
        echo "--- DNS ---"
        if command_exists resolvectl; then resolvectl status 2>&1; fi
        echo
        echo "--- NetworkManager: dispositivos ---"
        if command_exists nmcli; then nmcli device status 2>&1; else echo "(NetworkManager/nmcli indisponível)"; fi
        echo
        echo "--- NetworkManager: conexões ---"
        if command_exists nmcli; then nmcli connection show 2>&1; fi
    } | code_block
    echo
}

sec_firewall() {
    echo "## 13. Firewall"
    echo
    {
        if command_exists ufw; then
            echo "--- UFW ---"
            sudo ufw status verbose 2>&1
        elif command_exists nft; then
            echo "--- nftables ---"
            sudo nft list ruleset 2>&1
        else
            echo "(nenhum firewall gerenciável encontrado — ufw/nftables)"
        fi
    } | code_block
    echo
}

sec_tailscale() {
    echo "## 14. Tailscale"
    echo
    {
        if command_exists tailscale; then
            tailscale status 2>&1
            echo
            tailscale ip 2>&1
            echo
            tailscale version 2>&1
        else
            echo "(Tailscale não instalado)"
        fi
    } | code_block
    echo
}

sec_ssh() {
    echo "## 15. SSH"
    echo
    {
        ssh -V 2>&1
        echo
        systemctl status sshd --no-pager 2>&1
        echo
        echo "--- Sockets em escuta ---"
        ss -tulpn
    } | code_block
    echo
}

sec_scheduler() {
    echo "## 16. Scheduler & Prioridade de Processos"
    echo
    {
        echo "--- Kernel (verificação BORE) ---"
        uname -r
        if [ -f /proc/config.gz ]; then
            zcat /proc/config.gz 2>/dev/null | grep -i sched_bore
        else
            echo "(/proc/config.gz indisponível — CONFIG_IKCONFIG_PROC desabilitado)"
        fi
        echo
        echo "--- ananicy-cpp ---"
        systemctl status ananicy-cpp --no-pager 2>&1
        echo
        echo "--- systemd-oomd ---"
        systemctl status systemd-oomd --no-pager 2>&1
    } | code_block
    echo
}

sec_pacotes() {
    echo "## 17. Gerenciador de Pacotes"
    echo
    {
        if command_exists pacman; then
            echo "--- Distro: Arch-based (pacman) ---"
            pacman --version
            echo
            echo "--- pacman.conf ---"
            grep -vE '^\s*#|^\s*$' /etc/pacman.conf
            echo
            echo "--- makepkg.conf (relevante) ---"
            grep -E '^(MAKEFLAGS|CFLAGS|CXXFLAGS|RUSTFLAGS|LDFLAGS|BUILDENV|OPTIONS|INTEGRITY_CHECK|DLAGENTS|PACKAGER|COMPRESSXZ|COMPRESSZST)' /etc/makepkg.conf
            echo
            echo "--- Pacotes explícitos ---"
            pacman -Qe
            echo
            echo "--- Pacotes órfãos ---"
            pacman -Qdt 2>/dev/null
            echo
            echo "--- Pacotes foreign / AUR (instalados via paru/yay/etc) ---"
            pacman -Qm

        elif command_exists emerge; then
            echo "--- Distro: Gentoo (Portage) ---"
            if command_exists eselect; then
                eselect profile show 2>&1
                echo
            fi
            echo "--- make.conf (relevante) ---"
            grep -vE '^\s*#|^\s*$' /etc/portage/make.conf 2>/dev/null
            echo
            echo "--- Pacotes explicitamente instalados (@world) ---"
            if command_exists qlist; then
                qlist -Iv 2>&1
            else
                echo "(qlist não instalado — emerge app-portage/portage-utils)"
            fi
            echo
            echo "--- Pacotes órfãos (não requeridos por nada) ---"
            if command_exists emerge; then
                emerge --depclean --pretend 2>&1 | tail -n 30
            fi

        elif command_exists apt-get; then
            echo "--- Distro: Debian-based (APT) ---"
            apt-get --version | head -n1
            echo
            echo "--- Pacotes instalados manualmente ---"
            apt-mark showmanual
            echo
            echo "--- Pacotes órfãos (autoremovíveis) ---"
            apt-get -s autoremove 2>&1 | grep -E '^(Remv|The following)'

        else
            echo "(nenhum gerenciador de pacotes conhecido encontrado — pacman/emerge/apt-get)"
        fi
    } | code_block
    echo
}

sec_flatpak() {
    echo "## 18. Flatpak"
    echo
    {
        if command_exists flatpak; then
            flatpak --version
            echo
            flatpak list --app
        else
            echo "(flatpak não instalado)"
        fi
    } | code_block
    echo
}

sec_sudoers() {
    echo "## 19. Sudoers (usuário atual)"
    echo
    {
        sudo -l 2>&1
    } | code_block
    echo
}

sec_compiladores() {
    echo "## 20. Compiladores (GCC / Rust)"
    echo
    {
        gcc --version
        echo
        g++ --version
        echo
        echo "--- Caminho do GCC ---"
        which gcc
        readlink -f "$(which gcc)"
        echo
        echo "--- Opções de target do GCC ---"
        gcc -Q --help=target 2>/dev/null | grep -E 'march|mtune'
        echo
        echo "--- Rust ---"
        if command_exists rustc; then
            rustc --version
            cargo --version
        else
            echo "(rustc/cargo não instalados)"
        fi
        echo
        echo "--- Microcode instalado ---"
        pacman -Q intel-ucode amd-ucode 2>/dev/null
    } | code_block
    echo
}

sec_ccache() {
    echo "## 21. CCACHE"
    echo
    {
        if command_exists ccache; then
            ccache --version
            echo
            ccache --show-config
            echo
            ccache --show-stats
        else
            echo "(ccache não instalado)"
        fi
    } | code_block
    echo
}

sec_distcc() {
    echo "## 22. DISTCC"
    echo
    {
        if command_exists distcc; then
            distcc --version
        else
            echo "(distcc não instalado)"
        fi
        echo
        echo "--- DISTCC_HOSTS ---"
        echo "${DISTCC_HOSTS:-não definido}"
        echo
        echo "--- Hosts distcc ---"
        if command_exists distcc; then distcc --show-hosts 2>&1; fi
        echo
        echo "--- Serviço distccd ---"
        systemctl status distccd --no-pager 2>&1
        echo
        echo "--- Configuração do distccd ---"
        systemctl cat distccd 2>&1
    } | code_block
    echo
}

sec_servicos() {
    echo "## 23. Serviços systemd"
    echo
    {
        echo "--- Serviços de sistema com falha ---"
        systemctl --failed
        echo
        echo "--- Serviços de sistema em execução ---"
        systemctl list-units --type=service --state=running --no-pager
        echo
        echo "--- Timers ---"
        systemctl list-timers --all --no-pager
        echo
        echo "--- Serviços de usuário com falha ---"
        systemctl --user --failed 2>&1
        echo
        echo "--- Serviços de usuário em execução ---"
        systemctl --user list-units --type=service --state=running --no-pager 2>&1
    } | code_block
    echo
}

sec_kernel_boot() {
    echo "## 24. Kernel / Boot"
    echo
    {
        echo "--- Cmdline ---"
        cat /proc/cmdline
        echo
        echo "--- Módulos carregados (contagem) ---"
        lsmod | wc -l
        echo
        echo "--- Bootloader ---"
        if command_exists bootctl; then
            bootctl status 2>&1
        elif command_exists efibootmgr; then
            efibootmgr -v 2>&1
        else
            echo "(bootctl/efibootmgr indisponíveis)"
        fi
    } | code_block
    echo
}

sec_boot_erros() {
    echo "## 25. Erros do Boot Atual"
    echo
    { journalctl -p 3 -b --no-pager 2>&1 | filter_noise; } | code_block
    echo
}

sec_boot_warnings() {
    echo "## 26. Warnings do Boot Atual"
    echo
    { journalctl -b -p warning --no-pager 2>&1 | filter_noise; } | code_block
    echo
}

# =============================================================================
# MONTAGEM DO RELATÓRIO (fonte única de dados — humano e AI usam o mesmo texto)
# =============================================================================

generate_report() {
    local hostname_val
    hostname_val="$(hostname)"

    echo "# 📋 Diagnóstico do Sistema — $hostname_val"
    echo
    echo "**Data:** $(date '+%Y-%m-%d %H:%M:%S %Z')"
    echo
    echo "---"
    echo

    sec_sistema
    sec_cpu
    sec_memoria
    sec_armazenamento
    sec_armazenamento_saude
    sec_gpu
    sec_opengl
    sec_temperaturas
    sec_bateria
    sec_display
    sec_input
    sec_rede
    sec_firewall
    sec_tailscale
    sec_ssh
    sec_scheduler
    sec_pacotes
    sec_flatpak
    sec_sudoers
    sec_compiladores
    sec_ccache
    sec_distcc
    sec_servicos
    sec_kernel_boot
    sec_boot_erros
    sec_boot_warnings

    echo "---"
    echo
    echo "_Fim do diagnóstico — gerado por $SCRIPT_NAME v${SCRIPT_VERSION}_"
}

# =============================================================================
# HELP / VERSION
# =============================================================================

show_help() {
    cat <<EOF
$SCRIPT_NAME v$SCRIPT_VERSION — snapshot de diagnóstico do sistema Linux

USO:
    scan-to-ai [OPÇÃO]

OPÇÕES:
    (sem opção)          Mostra modo humano na tela (glow) e copia modo AI
                         para a área de transferência. Uso do dia a dia.
    --human              Mostra modo humano na tela. Não mexe no clipboard.
    --ai                 Mostra modo AI (Markdown puro) na tela. Não mexe no clipboard.
    --export             Exporta para ~/${SCRIPT_NAME}-output_TIMESTAMP.txt
                         (conteúdo em modo AI, a menos que combinado com --human)
    --export --human     Exporta em modo humano (Markdown renderizado pelo glow)
    --export --ai        Exporta em modo AI (Markdown puro)
    -v, --version        Mostra a versão do script e das ferramentas usadas
    -h, --help           Mostra esta ajuda

EXEMPLOS:
    scan-to-ai                    # uso diário: vê na tela, copia pro Claude
    scan-to-ai --ai                # inspeciona o Markdown puro antes de colar
    scan-to-ai --export --human    # salva um relatório legível pra arquivo

DEPENDÊNCIAS OPCIONAIS (o script funciona sem elas, com fallback em texto puro):
    glow            renderização Markdown no terminal (modo humano)
    xclip           clipboard no X11
    wl-clipboard    clipboard no Wayland (comando wl-copy)
EOF
}

show_version() {
    echo "$SCRIPT_NAME v$SCRIPT_VERSION"
    echo
    echo "Ferramentas:"
    if command_exists glow; then
        echo "  glow:    $(glow --version 2>&1 | head -n1)"
    else
        echo "  glow:    não instalado"
    fi
    if command_exists xclip; then
        echo "  xclip:   $(xclip -version 2>&1 | head -n1)"
    else
        echo "  xclip:   não instalado"
    fi
    if command_exists wl-copy; then
        echo "  wl-copy: $(wl-copy --version 2>&1 | head -n1)"
    else
        echo "  wl-copy: não instalado"
    fi
    echo "  bash:    $BASH_VERSION"
}

# =============================================================================
# ARGUMENTOS
# =============================================================================

explicit_mode=""   # "" (padrão) | "human" | "ai"
do_export=false

while [ $# -gt 0 ]; do
    case "$1" in
        -h|--help)
            show_help
            exit 0
            ;;
        -v|--version)
            show_version
            exit 0
            ;;
        --human)
            explicit_mode="human"
            ;;
        --ai)
            explicit_mode="ai"
            ;;
        --export)
            do_export=true
            ;;
        *)
            echo "Opção desconhecida: $1" >&2
            echo "Use 'scan-to-ai --help' para ver as opções disponíveis." >&2
            exit 1
            ;;
    esac
    shift
done

# =============================================================================
# EXECUÇÃO
# =============================================================================

report_md="$(generate_report)"

if $do_export; then
    export_mode="${explicit_mode:-ai}"
    export_file="$HOME/${SCRIPT_NAME}-output_$(date +%Y%m%d_%H%M%S).txt"

    render_content "$report_md" "$export_mode" > "$export_file"

    echo "✅ Exportado (modo $export_mode) para: $export_file"
    exit 0
fi

if [ -n "$explicit_mode" ]; then
    # Flag explícita: só exibe na tela, sem tocar no clipboard.
    render_content "$report_md" "$explicit_mode"
else
    # Comportamento padrão: tela em modo humano + clipboard em modo AI.
    render_content "$report_md" "human"
    echo
    if copy_to_clipboard "$report_md"; then
        echo "📋 Copiado para a área de transferência (modo AI)."
    fi
fi