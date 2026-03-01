#!/usr/bin/env bash
#
#    portage-unused-ranker.sh - Rank Portage packages by "usefulness"
#
#    Site:       https://github.com/jKy0n
#    Author:     jKyon (John Kennedy Loria Segundo)
#    Maintence:  jKyon
#
# ------------------------------------------------------------------------ #
#    This script ranks installed Portage packages by how many OTHER
#    installed packages depend on them (reverse-dependency count).
#
#    Metric used:  usage_score = count of reverse dependencies
#      Computed via:  equery -q depends <CP>
#      Each line of output is one installed package that depends on <CP>.
#      A score of 0 means nothing installed depends on that package,
#      making it the best candidate for removal / deselection.
#
#    Default scope is @selected (selected-packages + selected-sets),
#    which is the user's "world file" — safe and fast.
#    Use --world / -w to expand to the full @world set.
#
#    Output is designed to be stable, deterministic, and compatible
#    with `watch` (no colors, no pager, no interactive prompts).
#
#    Examples:
#      $ ./portage-unused-ranker.sh
#      $ ./portage-unused-ranker.sh --world
#      $ watch -n 60 ./portage-unused-ranker.sh
#      $ ./portage-unused-ranker.sh -a
#      $ ./portage-unused-ranker.sh -nd
#
# ------------------------------------------------------------------------ #
#    History:
#         v1.1 01/03/2026, jKyon:
#              - Parallel scoring via xargs -P $(nproc)
#              - Added -j/--jobs flag (default: nproc)
#         v1.0 01/03/2026, jKyon:
#              - Initial release
#              - Usage-score ranking via equery depends
#              - Chronological, alphabetical, reverse sorting
#              - Zero-dependency filter (--no-dependency)
#              - @selected (default) and @world scope
# ------------------------------------------------------------------------ #
#    Tested on:
#         bash 5.2+
#         gentoolkit (equery) 0.6+
# ------------------------------------------------------------------------ #
#    Thanks and credits:
#         Gentoo community and wiki
# ------------------------------------------------------------------------ #

# ========================= Safe Bash Settings =========================== #
# -e : exit on error (we handle expected failures ourselves)
# -u : treat unset variables as errors
# -o pipefail : a pipeline fails if any command in it fails
set -euo pipefail

# ========================= Script Metadata ============================== #
readonly SCRIPT_NAME="$(basename "$0")"
readonly SCRIPT_VERSION="1.1"
readonly SCRIPT_PATH="/home/jkyon/ShellScript/TheseusMachine/portage-tools/portage-unused-ranker/portage-unused-ranker.sh"

# Portage world-file paths
readonly WORLD_FILE="/var/lib/portage/world"
readonly WORLD_SETS_FILE="/var/lib/portage/world_sets"
readonly PKGDB="/var/db/pkg"

# ========================= Default Flags ================================ #
SORT_MODE="usage"          # usage | alphabetical | chronological
REVERSE=false              # reverse the final sort?
NO_DEPENDENCY=false        # show only score==0 packages?
SCOPE="selected"           # selected | world

# Parallel jobs: default to all available cores.
# On a 5950X this is 32 (16C/32T). Override with -j/--jobs.
PARALLEL_JOBS="$(nproc 2>/dev/null || echo 1)"

# ========================= Help Text =================================== #
show_help() {
    cat <<EOF
${SCRIPT_NAME} v${SCRIPT_VERSION} — Rank Portage packages by reverse-dependency count.

DESCRIPTION
  Ranks packages from the @selected (or @world) set by how many installed
  packages depend on them. Packages at the TOP of the list have the fewest
  reverse dependencies and are the best candidates for removal/deselection.

  Metric:  usage_score = number of installed reverse dependencies
           (computed via: equery -q depends <category/package>)

USAGE
  ${SCRIPT_NAME} [OPTIONS]

OPTIONS
  -h,  --help             Show this help message and exit.
  -v,  --version          Show script version and tool versions, then exit.
  -a,  --alphabetical     Sort output alphabetically by category/package.
  -r,  --reverse          Reverse the current sort order.
  -c,  --chronological    Sort by install date (newest first by default).
  -nd, --no-dependency    Show only packages with zero reverse dependencies.
  -w,  --world            Operate on @world instead of @selected.
  -j N, --jobs N          Number of parallel scoring workers (default: nproc).
                          Each worker runs 'equery depends' for one package.
                          Higher values = faster on multi-core CPUs.

FLAG COMBINATIONS
  Flags can be freely combined. Priority:
    -c  overrides default usage sort (chronological takes priority).
    -a  selects alphabetical sort.
    -r  reverses whatever sort is active.
    -nd filters output AFTER scoring (only score==0 shown).

PORTAGE SETS (for reference)
  @selected          = selected-packages + selected-sets
  @world             = @selected + @system + @profile
  selected-packages  = /var/lib/portage/world (user world file)
  selected-sets      = /var/lib/portage/world_sets

LIMITATIONS
  - Set expansion for selected-sets uses 'emerge --pretend --emptytree'
    which can be slow for large sets. If expansion fails, only
    selected-packages are used (with a warning to stderr).
  - Indirect reverse deps (equery depends -D) are not used by default
    for speed; the direct installed-only count is used.

EXAMPLES
  1) Default: rank @selected by usage score (ascending, least-used first):
       ${SCRIPT_NAME}

  2) Rank @world packages:
       ${SCRIPT_NAME} --world

  3) Use with watch (refresh every 60 seconds):
       watch -n 60 ${SCRIPT_PATH}
       watch -n 60 ${SCRIPT_PATH} --world

  4) Alphabetical sort:
       ${SCRIPT_NAME} -a

  5) Only packages with zero reverse dependencies (removal candidates):
       ${SCRIPT_NAME} -nd

  6) Chronological sort, reversed (oldest first):
       ${SCRIPT_NAME} -c -r

  7) World scope, zero-dep filter:
       ${SCRIPT_NAME} -w -nd

  8) Limit parallel workers to 8:
       ${SCRIPT_NAME} -j 8

  9) Watch with 16 workers:
       watch -n 60 ${SCRIPT_PATH} -j 16

EOF
    exit 0
}

# ========================= Version Info ================================= #
show_version() {
    echo "${SCRIPT_NAME} v${SCRIPT_VERSION}"
    echo ""
    echo "Tool versions:"
    echo "  bash     : ${BASH_VERSION}"
    echo "  equery   : $(equery --version 2>&1 | head -1 || echo 'unknown')"
    echo "  awk      : $(awk --version 2>&1 | head -1 || echo 'unknown')"
    echo "  sort     : $(sort --version 2>&1 | head -1 || echo 'unknown')"
    echo "  grep     : $(grep --version 2>&1 | head -1 || echo 'unknown')"
    echo "  sed      : $(sed --version 2>&1 | head -1 || echo 'unknown')"
    echo "  date     : $(date --version 2>&1 | head -1 || echo 'unknown')"
    echo "  xargs    : $(xargs --version 2>&1 | head -1 || echo 'unknown')"
    echo ""
    echo "Parallelism:"
    echo "  nproc    : $(nproc 2>/dev/null || echo 'unknown')"
    echo "  jobs     : ${PARALLEL_JOBS}"
    exit 0
}

# ========================= Dependency Check ============================= #
# Verify that all required external commands are available before doing
# any real work. Print helpful Gentoo install hints if something is missing.
check_dependencies() {
    local missing=()

    # Map of command -> install hint (Gentoo-oriented)
    declare -A cmd_hints=(
        [bash]="(should be pre-installed)"
        [awk]="emerge sys-apps/gawk"
        [sort]="emerge sys-apps/coreutils"
        [grep]="emerge sys-apps/grep"
        [sed]="emerge sys-apps/sed"
        [date]="emerge sys-apps/coreutils"
        [xargs]="emerge sys-apps/findutils"
        [equery]="emerge app-portage/gentoolkit"
    )

    for cmd in bash awk sort grep sed date xargs equery; do
        if ! command -v "$cmd" &>/dev/null; then
            missing+=("$cmd")
        fi
    done

    if [[ ${#missing[@]} -gt 0 ]]; then
        echo "ERROR: Missing required command(s):" >&2
        for cmd in "${missing[@]}"; do
            echo "  - ${cmd}  (install: ${cmd_hints[$cmd]:-unknown})" >&2
        done
        echo "" >&2
        echo "Install missing dependencies and try again." >&2
        echo "Note: 'watch' is optional but recommended:" >&2
        echo "  emerge sys-process/procps" >&2
        exit 1
    fi
}

# ========================= Package List Builders ======================== #

# get_selected_packages:
#   Read /var/lib/portage/world for selected-packages atoms.
#   These are bare CP atoms (category/package), one per line.
#   We ignore blank lines and comments.
get_selected_packages() {
    if [[ ! -r "$WORLD_FILE" ]]; then
        echo "ERROR: Cannot read ${WORLD_FILE}" >&2
        exit 1
    fi
    # Strip comments, blank lines, and any trailing whitespace
    grep -v '^\s*#' "$WORLD_FILE" | grep -v '^\s*$' | sed 's/\s*$//'
}

# get_selected_sets:
#   Read /var/lib/portage/world_sets and try to expand each set into
#   its member CP atoms. This uses `emerge --pretend --emptytree @<set>`
#   and parses the output. If expansion fails, returns empty silently.
get_selected_sets() {
    # If the sets file doesn't exist or is empty, nothing to do
    if [[ ! -r "$WORLD_SETS_FILE" ]]; then
        return 0
    fi

    local sets
    sets="$(grep -v '^\s*#' "$WORLD_SETS_FILE" 2>/dev/null | grep -v '^\s*$' | sed 's/\s*$//' || true)"

    if [[ -z "$sets" ]]; then
        return 0
    fi

    # For each set, try to expand it via emerge --pretend --quiet
    # This can be slow for large sets, but selected-sets are typically few.
    while IFS= read -r setname; do
        # Expand set: emerge prints "[ebuild ...] cat/pkg-ver::repo" lines
        # We extract the CP (category/package) portion only.
        # Using --emptytree to see ALL members, --quiet for less noise.
        # || true: do not fail if a set cannot be expanded (e.g. it doesn't exist)
        emerge --pretend --emptytree --quiet "@${setname}" 2>/dev/null \
            | sed -n 's/^\[ebuild[^]]*\]\s*//p' \
            | sed 's/-[0-9].*$//' \
            | sed 's/::.*$//' \
            || echo "WARNING: Could not expand set '@${setname}', skipping." >&2
    done <<< "$sets"
}

# get_selected_atoms:
#   Return unique CP atoms from @selected (selected-packages + selected-sets).
get_selected_atoms() {
    {
        get_selected_packages
        get_selected_sets
    } | sort -u
}

# get_world_atoms:
#   Expand @world to unique CP atoms.
#   Uses: emerge --pretend --emptytree --quiet @world
#   This is heavier but gives the full picture.
#   Fallback: if emerge expansion fails, fall back to @selected.
get_world_atoms() {
    local atoms
    # emerge --color=n to suppress color even if EMERGE_DEFAULT_OPTS has it
    atoms="$(emerge --color=n --pretend --emptytree --quiet @world 2>/dev/null \
        | sed -n 's/^\[ebuild[^]]*\]\s*//p' \
        | sed 's/-[0-9][0-9a-zA-Z._-]*\(:[^ ]*\)\?\s*.*$//' \
        | sed 's/::.*$//' \
        | sort -u)" || true

    if [[ -z "$atoms" ]]; then
        echo "WARNING: Could not expand @world via emerge, falling back to @selected." >&2
        get_selected_atoms
        return
    fi

    echo "$atoms"
}

# get_package_list:
#   Return the list of unique CP atoms based on the configured SCOPE.
get_package_list() {
    case "$SCOPE" in
        selected) get_selected_atoms ;;
        world)    get_world_atoms ;;
        *)        echo "ERROR: Unknown scope '${SCOPE}'" >&2; exit 1 ;;
    esac
}

# ========================= Scoring Functions ============================ #

# compute_usage_score:
#   For a given CP atom, count how many installed packages depend on it.
#   Uses: equery -q depends <CP>
#   The -q flag gives quiet output (no headers), one dependent per line.
#   Returns the count as a number on stdout.
compute_usage_score() {
    local cp="$1"
    local count

    # equery depends lists installed packages that depend on <cp>.
    # -q suppresses headers. We count non-empty lines.
    # If equery fails (e.g., package not found), score is 0.
    count="$(equery -q depends "$cp" 2>/dev/null | grep -c '.' || true)"
    echo "${count:-0}"
}

# get_build_time:
#   For a given CP atom, find the newest BUILD_TIME from /var/db/pkg.
#   Multiple versions may be installed; we want the most recent one.
#   BUILD_TIME contains epoch seconds.
#   Returns the epoch timestamp, or 0 if not found.
get_build_time() {
    local cp="$1"
    local cat="${cp%%/*}"
    local pkg="${cp##*/}"
    local newest=0

    # Glob for all installed versions of this CP.
    # /var/db/pkg/category/package-version/BUILD_TIME
    # The directory name is PF (package-version-revision), so we glob pkg-*
    local build_dir="${PKGDB}/${cat}"
    if [[ ! -d "$build_dir" ]]; then
        echo "0"
        return
    fi

    # Match directories starting with exactly the package name followed by a dash and digit
    # This avoids matching "foo" against "foobar-1.0"
    local found_any=false
    for d in "${build_dir}/${pkg}"-[0-9]*/; do
        [[ -d "$d" ]] || continue
        found_any=true
        local bt_file="${d}BUILD_TIME"
        if [[ -r "$bt_file" ]]; then
            local bt
            bt="$(cat "$bt_file" 2>/dev/null | tr -d '[:space:]')"
            if [[ "$bt" =~ ^[0-9]+$ ]] && (( bt > newest )); then
                newest="$bt"
            fi
        fi
    done

    # If no versioned dir was found, the package might not be installed
    # (could be in the world file but not currently merged). Score = 0.
    echo "$newest"
}

# ========================= Main Processing ============================== #

# process_packages:
#   1) Get the package list for the chosen scope.
#   2) Score ALL packages in PARALLEL using xargs -P (reverse-dep count).
#   3) Optionally compute build_time for chronological sorting.
#   4) Apply filtering (--no-dependency) and sorting.
#   5) Print final readable output.
#
# Parallelism strategy:
#   The bottleneck is `equery depends` — each call spawns a Python process
#   and scans the installed package VDB.  On a single core this takes
#   ~0.3–0.8 s per package.  With 200+ packages that's 60–160 s sequential.
#   Using xargs -P with $(nproc) workers (e.g. 32 on a Ryzen 5950X),
#   wall-time drops to roughly total_pkgs * per_pkg_time / nproc, i.e. ~3–8 s.
#   BUILD_TIME reads are trivial file-reads, so they stay sequential.
process_packages() {
    local pkg_list
    pkg_list="$(get_package_list)"

    if [[ -z "$pkg_list" ]]; then
        echo "No packages found in @${SCOPE}."
        exit 0
    fi

    local total
    total="$(echo "$pkg_list" | wc -l)"

    # =================================================================
    # Phase 1: Parallel reverse-dependency scoring
    # =================================================================
    # Each xargs worker calls `equery -q depends <CP>`, counts output
    # lines, and prints  score<TAB>CP  to stdout.
    # xargs -P runs up to PARALLEL_JOBS workers concurrently.
    #
    # Pattern:  xargs -I {} bash -c '...' _ {}
    #   - xargs substitutes {} with the CP atom (only the trailing one)
    #   - bash -c receives it as positional param $1 (after the _ filler)
    #   - The single-quoted body has no {} so xargs won't mangle it
    #
    # Output order is NON-DETERMINISTIC (jobs finish at different times),
    # but we sort everything in Phase 3 anyway.

    echo "Scoring ${total} packages (${PARALLEL_JOBS} parallel workers)..." >&2

    local scored_lines
    scored_lines="$(echo "$pkg_list" | xargs -P "$PARALLEL_JOBS" -I {} bash -c '
        count=$(equery -q depends "$1" 2>/dev/null | grep -c "." || true)
        printf "%s\t%s\n" "${count:-0}" "$1"
    ' _ {})"

    echo "Scoring complete." >&2

    # =================================================================
    # Phase 2: Filter (--no-dependency)
    # =================================================================
    # If -nd is set, keep only packages where score == 0 (no reverse deps).
    # This runs AFTER parallel scoring so we already have the data.
    if [[ "$NO_DEPENDENCY" == true ]]; then
        scored_lines="$(echo "$scored_lines" | awk -F'\t' '$1 == 0')"
    fi

    if [[ -z "$scored_lines" ]]; then
        echo "No packages matched the given filters in @${SCOPE}."
        exit 0
    fi

    # =================================================================
    # Phase 3: Build final metric column + sort
    # =================================================================
    local final_lines

    if [[ "$SORT_MODE" == "chronological" ]]; then
        # Replace the score column with BUILD_TIME (epoch seconds).
        # Reading BUILD_TIME is just cat-ing small files from /var/db/pkg,
        # extremely fast — no need to parallelize this part.
        final_lines="$(echo "$scored_lines" | while IFS=$'\t' read -r _score cp; do
            [[ -z "$cp" ]] && continue
            printf '%s\t%s\n' "$(get_build_time "$cp")" "$cp"
        done)"

        # Sort by build_time descending (newest first) by default;
        # -r flag reverses to oldest first.
        if [[ "$REVERSE" == true ]]; then
            final_lines="$(echo "$final_lines" | sort -t$'\t' -k1,1n -k2,2)"
        else
            final_lines="$(echo "$final_lines" | sort -t$'\t' -k1,1nr -k2,2)"
        fi

    elif [[ "$SORT_MODE" == "alphabetical" ]]; then
        # Sort alphabetically by CP (column 2)
        if [[ "$REVERSE" == true ]]; then
            final_lines="$(echo "$scored_lines" | sort -t$'\t' -k2,2r)"
        else
            final_lines="$(echo "$scored_lines" | sort -t$'\t' -k2,2)"
        fi

    else
        # Default: sort by usage_score ascending (least-used at top)
        if [[ "$REVERSE" == true ]]; then
            final_lines="$(echo "$scored_lines" | sort -t$'\t' -k1,1nr -k2,2)"
        else
            final_lines="$(echo "$scored_lines" | sort -t$'\t' -k1,1n -k2,2)"
        fi
    fi

    # =================================================================
    # Phase 4: Display
    # =================================================================
    # Simple left-aligned columns. No color, no pager — watch-friendly.

    local count
    count="$(echo "$final_lines" | grep -c '.' || true)"

    echo "=== portage-unused-ranker v${SCRIPT_VERSION} ==="
    echo "Scope: @${SCOPE} | Sort: ${SORT_MODE}$(${REVERSE} && echo ' (reversed)' || true) | Packages: ${count} | Jobs: ${PARALLEL_JOBS}"
    echo "---"

    if [[ "$SORT_MODE" == "chronological" ]]; then
        # Print: human-readable date + CP
        echo "$final_lines" | while IFS=$'\t' read -r bt cp; do
            [[ -z "$cp" ]] && continue
            local human_date
            if (( bt > 0 )); then
                human_date="$(date -d "@${bt}" '+%Y-%m-%d %H:%M' 2>/dev/null || echo 'unknown')"
            else
                human_date="unknown"
            fi
            printf "%-20s  %s\n" "$human_date" "$cp"
        done
    else
        # Print: score + CP
        echo "$final_lines" | while IFS=$'\t' read -r score cp; do
            [[ -z "$cp" ]] && continue
            printf "%-6s  %s\n" "$score" "$cp"
        done
    fi

    echo "---"
    echo "Done. ${count} packages ranked."
}

# ========================= Argument Parsing ============================= #
parse_args() {
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -h|--help)
                show_help
                ;;
            -v|--version)
                show_version
                ;;
            -a|--alphabetical)
                SORT_MODE="alphabetical"
                shift
                ;;
            -r|--reverse)
                REVERSE=true
                shift
                ;;
            -c|--chronological)
                SORT_MODE="chronological"
                shift
                ;;
            -nd|--no-dependency)
                NO_DEPENDENCY=true
                shift
                ;;
            -j|--jobs)
                if [[ -z "${2:-}" || ! "${2:-}" =~ ^[0-9]+$ || "${2:-}" -lt 1 ]]; then
                    echo "ERROR: -j/--jobs requires a positive integer argument." >&2
                    exit 1
                fi
                PARALLEL_JOBS="$2"
                shift 2
                ;;
            -w|--world)
                SCOPE="world"
                shift
                ;;
            *)
                echo "ERROR: Unknown option '${1}'" >&2
                echo "Use '${SCRIPT_NAME} --help' for usage information." >&2
                exit 1
                ;;
        esac
    done
}

# ========================= Entry Point ================================== #
main() {
    parse_args "$@"
    check_dependencies
    process_packages
}

main "$@"