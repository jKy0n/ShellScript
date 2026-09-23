#!/usr/bin/env bash
#
#        Title:      compare-hash-folder.sh
#        Brief:      Compares the hash of every file in a source folder with its copy in a destination folder
#        Path:       /home/jkyon/ShellScript/Tools/compare-hash-folder/compare-hash-folder.sh
#        Author:     John Kennedy a.k.a. jKyon
#        Created:    2026-09-22
#        Updated:    2026-09-22
#        Notes:      Meant to validate copies (e.g. ISOs moved with rsync). Walks the source recursively,
#                    hashes each file and its counterpart at the same relative path in the destination,
#                    in parallel, and prints ✅ or ❌ per file. Exits 0 only if every file matches.
#
set -euo pipefail

VERSION="1.0"
PROG="compare-hash-folder"
HASH_TOOLS=(md5sum sha1sum sha224sum sha256sum sha384sum sha512sum b2sum)
CORE_DEPS=(bash find sort xargs nproc)

usage() {
    cat <<EOF
Usage: $PROG -i SOURCE -o DESTINATION [-t THREADS] [-m MODE]

Compares the hash of every file in SOURCE with the file at the same
relative path in DESTINATION.

Options:
  -h, --help             Show this help and exit
  -v, --version          Show the version and check dependencies
  -i, --input  DIR       Source folder (required)
  -o, --output DIR       Destination folder (required)
  -t, --threads N        Number of parallel jobs (default: nproc - 2 = $(default_threads))
  -m, --mode   TOOL      Hash tool: ${HASH_TOOLS[*]}
                         (default: sha256sum; short form like "sha512" also works)

Examples:
  $PROG -t 4 -m sha512sum -i ~/foo/bar -o ~/foo/baz
  $PROG -i ~/foo/bar -o ~/foo/baz

if necessary use --version to check dependencies
EOF
}

version() {
    local dep missing=()
    echo "$PROG $VERSION"
    echo
    echo "Dependencies:"
    for dep in "${CORE_DEPS[@]}" "${HASH_TOOLS[@]}"; do
        if command -v "$dep" >/dev/null 2>&1; then
            echo "  ✅ $dep"
        else
            echo "  ❌ $dep"
            missing+=("$dep")
        fi
    done
    echo
    if ((${#missing[@]})); then
        echo "Missing: ${missing[*]}"
        echo "Hint: find/xargs come from findutils, the rest from coreutils."
        return 1
    fi
    echo "All dependencies installed."
}

die() {
    echo "$PROG: $*" >&2
    echo "Try '$PROG --help' for more information." >&2
    exit 1
}

default_threads() {
    local n=$(($(nproc) - 2))
    ((n < 1)) && n=1
    echo "$n"
}

# Prints only the hash of a file. Reading from stdin avoids the "\" prefix
# that *sum tools add to names with special characters.
hash_of() {
    local out
    out=$("$HASH_MODE" <"$1") || return 1
    printf '%s' "${out%% *}"
}

# Runs once per source file (via xargs). Emits "STATUS<TAB>relative path<NUL>".
worker() {
    local src="$1" rel dst src_hash dst_hash
    rel="${src#"$SRC_DIR"/}"
    dst="$DST_DIR/$rel"

    if [[ ! -f "$dst" ]]; then
        printf 'MISSING\t%s\0' "$rel"
        return 0
    fi
    if ! src_hash=$(hash_of "$src") || ! dst_hash=$(hash_of "$dst"); then
        printf 'ERROR\t%s\0' "$rel"
        return 0
    fi
    if [[ "$src_hash" == "$dst_hash" ]]; then
        printf 'OK\t%s\0' "$rel"
    else
        printf 'MISMATCH\t%s\0' "$rel"
    fi
}

input="" output="" threads="" mode="sha256sum"

while (($#)); do
    case "$1" in
        -h | --help) usage; exit 0 ;;
        -v | --version) version; exit $? ;;
        -i | --input | -o | --output | -t | --threads | -m | --mode)
            (($# >= 2)) || die "option '$1' requires an argument"
            case "$1" in
                -i | --input) input="$2" ;;
                -o | --output) output="$2" ;;
                -t | --threads) threads="$2" ;;
                -m | --mode) mode="$2" ;;
            esac
            shift 2
            ;;
        *) die "unknown option '$1'" ;;
    esac
done

[[ -n "$input" && -n "$output" ]] || die "both -i (source) and -o (destination) are required"
[[ -d "$input" ]] || die "source folder not found: $input"
[[ -d "$output" ]] || die "destination folder not found: $output"

[[ -z "$threads" ]] && threads=$(default_threads)
[[ "$threads" =~ ^[1-9][0-9]*$ ]] || die "threads must be a positive integer: $threads"

requested_mode="$mode"
[[ "$mode" == *sum ]] || mode="${mode}sum"
[[ " ${HASH_TOOLS[*]} " == *" $mode "* ]] || die "unsupported mode '$requested_mode' (use one of: ${HASH_TOOLS[*]})"
command -v "$mode" >/dev/null 2>&1 || die "'$mode' is not installed (see --version)"

SRC_DIR=$(cd "$input" && pwd -P)
DST_DIR=$(cd "$output" && pwd -P)
HASH_MODE="$mode"
export SRC_DIR DST_DIR HASH_MODE
export -f worker hash_of

echo "Mode: $HASH_MODE | Threads: $threads"
echo "Source:      $SRC_DIR"
echo "Destination: $DST_DIR"
echo

total=0 ok=0
while IFS=$'\t' read -r -d '' status rel; do
    total=$((total + 1))
    case "$status" in
        OK) ok=$((ok + 1)); echo "✅ $rel" ;;
        MISSING) echo "❌ $rel (missing in destination)" ;;
        MISMATCH) echo "❌ $rel (hash mismatch)" ;;
        *) echo "❌ $rel (read error)" ;;
    esac
done < <(find "$SRC_DIR" -type f -print0 | sort -z |
    xargs -0 -r -n 1 -P "$threads" bash -c 'worker "$1"' _)

if ((total == 0)); then
    echo "No files found in $SRC_DIR" >&2
    exit 1
fi

echo
echo "Result: $ok/$total OK, $((total - ok)) failed"
((ok == total))
