#!/bin/bash

# copy-to-clipboard 2.0 - Bash Fallback Script
# Dual-output: Terminal (humanized) + Clipboard (IA-optimized)
# Logic: 0=IA, 1=Humanized

version="2.0"

# ========== VERSION & HELP ==========

case "$1" in
    -h|--help)
        cat << 'EOF'
copy-to-clipboard 2.0 - Dual-Output Clipboard Manager

USAGE:
    copy-to-clipboard [OPTIONS] [COMMAND]
    command | copy-to-clipboard [OPTIONS]

OPTIONS:
    -h, --help              Show this help message
    -v, --version           Show version information
    -H, --human             Humanized output (terminal + clipboard)
    -s, --silent            No terminal output (only confirmation)
    -e, --export            Save to file + IA-format output

LOGIC:
    0 = IA-optimized (structured, parseable)
    1 = Humanized (visual, readable)

DEFAULTS:
    - Terminal: 1 (humanized - you debug)
    - Clipboard: 0 (IA-format - AI analyzes)

EXAMPLES:
    # Copy for AI (default - best for debugging)
    docker logs app | copy-to-clipboard

    # Humanized everywhere
    docker logs app | copy-to-clipboard --human

    # Silent mode (for scripts)
    docker logs app | copy-to-clipboard --silent

    # Export to file + IA-format
    docker logs app | copy-to-clipboard --export

FEATURES:
    ✓ Dual-output: humanized terminal + IA-optimized clipboard
    ✓ Automatic fallback: xclip → file
    ✓ SSH-friendly
    ✓ Silent mode for scripts
    ✓ File export for emergencies
    ✓ Metadata in IA-format (status, method, size, timestamp)

For more info: https://github.com/yourusername/dotfiles
EOF
        exit 0
        ;;
    -v|--version)
        if command -v xclip &> /dev/null; then
            xclip_version=$(xclip -version 2>&1 | head -n1 | grep -oE '[0-9]+\.[0-9]+' || echo "unknown")
            echo "copy-to-clipboard version $version (with xclip v$xclip_version)"
        else
            echo "copy-to-clipboard version $version (xclip not found)"
        fi
        exit 0
        ;;
esac

# ========== VERIFY XCLIP ==========

if ! command -v xclip &> /dev/null; then
    echo "❌ Erro: xclip não está instalado"
    exit 1
fi

# ========== PARSE FLAGS ==========

human=0
silent=0
export_flag=0
input=""

while [[ $# -gt 0 ]]; do
    case "$1" in
        -H|--human)
            human=1
            shift
            ;;
        -s|--silent)
            silent=1
            shift
            ;;
        -e|--export)
            export_flag=1
            shift
            ;;
        *)
            input="$*"
            break
            ;;
    esac
done

# ========== DERIVE FORMATS ==========
# Default: terminal=1 (humanized), clipboard=0 (IA-format)
# --human flag: both become 1 (humanized)

terminal_format=1
clipboard_format=0

# If --human flag, change both to humanized (1)
if [[ $human -eq 1 ]]; then
    terminal_format=1
    clipboard_format=1
fi

# If explicit --export, terminal becomes IA-format (0)
if [[ $export_flag -eq 1 ]]; then
    terminal_format=0
fi

# ========== READ INPUT ==========

if [[ -z "$input" ]]; then
    if [[ ! -t 0 ]]; then
        # Read from stdin (pipe)
        input="$(cat)"
    else
        # No input and no pipe
        echo "❌ Uso: comando | copy-to-clipboard [OPTIONS]"
        echo "   Use 'copy-to-clipboard --help' para mais informações"
        exit 1
    fi
else
    # Execute command passed as argument
    input="$(eval "$@" 2>&1)"
fi

content_size=$(echo -n "$input" | wc -c)
timestamp=$(date -u +%Y-%m-%dT%H:%M:%S.000Z)

# ========== BUILD CLIPBOARD CONTENT ==========

clipboard_content=""

if [[ $clipboard_format -eq 0 ]]; then
    # IA-format (0)
    clipboard_content="[COPY_STATUS] success
[COPY_METHOD] xclip
[CONTENT_SIZE] $content_size bytes
[TIMESTAMP] $timestamp
---
$input
---"
else
    # Humanized (1)
    clipboard_content="$input"
fi

# ========== COPY TO CLIPBOARD ==========

clipboard_success=0

if echo -n "$clipboard_content" | xclip -selection clipboard 2>/dev/null; then
    clipboard_success=1
else
    # Fallback: save to file
    export_flag=1
    clipboard_success=0
fi

# ========== TERMINAL OUTPUT ==========

if [[ $silent -eq 0 ]]; then
    if [[ $terminal_format -eq 0 ]]; then
        # IA-format (0) - only with --export
        echo "$clipboard_content"
    else
        # Humanized (1) - default
        if [[ $clipboard_success -eq 1 ]]; then
            echo "✅ Copiado com xclip"
        else
            echo "⚠️  Clipboard indisponível"
            echo "   Ativando fallback: --export automático"
        fi

        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo "📋 Conteúdo ($content_size bytes):"
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo "$input"
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    fi
else
    echo "✅ Copiado (--silent)"
fi

# ========== EXPORT (FILE) ==========

if [[ $export_flag -eq 1 ]]; then
    export_timestamp=$(date +%Y-%m-%d_%H-%M-%S)
    export_file="$HOME/clipboard_${export_timestamp}.txt"

    # Save to file
    echo -n "$clipboard_content" > "$export_file"

    if [[ $silent -eq 0 ]]; then
        if [[ $terminal_format -eq 1 ]]; then
            echo "📄 Salvo em: $export_file"
        else
            echo "[EXPORT_FILE] $export_file"
        fi
    fi

    # If clipboard failed, try to copy from file
    if [[ $clipboard_success -eq 0 ]]; then
        if [[ $silent -eq 0 ]] && [[ $terminal_format -eq 1 ]]; then
            echo ""
            echo "💡 Dica: Para copiar do arquivo para clipboard:"
            echo "   cat $export_file | xclip -selection clipboard"
        fi
    fi
fi