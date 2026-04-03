#!/usr/bin/env bash
set -euo pipefail

SCRIPT_NAME="clean.sh"
PROJECT_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
LOG_DIR="${PROJECT_ROOT}/logs"
LOG_FILE="${LOG_DIR}/clean-$(date +%Y%m%d-%H%M%S).log"

AUTO_YES=false
DRY_RUN=false
ALL_LOGS=false
RUN_MAVEN_CLEAN=false
RUN_LOG_CLEANUP=true
RUN_TEMP_CLEANUP=true

LOG_DIRS=("${PROJECT_ROOT}/logs" "${PROJECT_ROOT}/utils/scripts/logs")
TEMP_PATTERNS=("*.tmp" "*.temp" "*~" "*.pid")

mkdir -p "$LOG_DIR"

error_handler() {
    echo "❌ Error in ${SCRIPT_NAME} at line $1"
    echo "❌ Last command: ${BASH_COMMAND}"
    echo "📋 Check log file: ${LOG_FILE}"
    exit 1
}

trap 'error_handler $LINENO' ERR

log() {
    local message="$1"
    echo "$message" | tee -a "$LOG_FILE"
}

run_cmd() {
    local cmd="$1"
    if [[ "$DRY_RUN" == true ]]; then
        log "[dry-run] $cmd"
    else
        eval "$cmd" 2>&1 | sed 's/\x1b\[[0-9;]*m//g' | tee -a "$LOG_FILE"
    fi
}

confirm_with_default() {
    local question="$1"
    local default_answer="${2:-N}"

    if [[ "$AUTO_YES" == true ]]; then
        [[ "$default_answer" =~ ^[Yy]$ ]]
        return
    fi

    local hint="[y/N]"
    if [[ "$default_answer" =~ ^[Yy]$ ]]; then
        hint="[Y/n]"
    fi

    read -r -p "$question $hint: " answer
    if [[ -z "$answer" ]]; then
        [[ "$default_answer" =~ ^[Yy]$ ]]
    else
        [[ "$answer" =~ ^[Yy]$ ]]
    fi
}

print_help() {
    cat <<'EOF'
Usage: ./utils/scripts/clean.sh [options]

Interactive cleanup script (decide each action during execution).

Options:
  --yes          Non-interactive shortcut (accept defaults)
  --dry-run      Show what would be removed without deleting
  -h, --help     Show this help

Examples:
  ./utils/scripts/clean.sh
  ./utils/scripts/clean.sh --yes
  ./utils/scripts/clean.sh --dry-run
EOF
}

parse_args() {
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --yes)
                AUTO_YES=true
                ;;
            --dry-run)
                DRY_RUN=true
                ;;
            -h|--help)
                print_help
                exit 0
                ;;
            *)
                echo "Unknown option: $1"
                print_help
                exit 1
                ;;
        esac
        shift
    done
}

choose_runtime_actions() {
    if [[ "$AUTO_YES" == true ]]; then
        return
    fi

    log "🧭 Choose what to clean (y/n):"

    if confirm_with_default "Run Maven clean (target/build cleanup)?" "N"; then
        RUN_MAVEN_CLEAN=true
    fi

    if ! confirm_with_default "Clean log files?" "Y"; then
        RUN_LOG_CLEANUP=false
    fi

    if [[ "$RUN_LOG_CLEANUP" == true ]] && confirm_with_default "Remove all logs (instead of only older than 7 days)?" "N"; then
        ALL_LOGS=true
    fi

    if ! confirm_with_default "Clean temporary files (*.tmp, *.temp, *~, *.pid)?" "Y"; then
        RUN_TEMP_CLEANUP=false
    fi
}

cleanup_logs() {
    if [[ "$RUN_LOG_CLEANUP" == false ]]; then
        log "⏭️  Skipping log cleanup."
        return
    fi

    log "🧾 Cleaning log files..."
    for dir in "${LOG_DIRS[@]}"; do
        [[ -d "$dir" ]] || continue
        if [[ "$ALL_LOGS" == true ]]; then
            run_cmd "find \"$dir\" -type f -name '*.log' -delete"
        else
            run_cmd "find \"$dir\" -type f -name '*.log' -mtime +7 -delete"
        fi
    done
}

cleanup_temp_files() {
    if [[ "$RUN_TEMP_CLEANUP" == false ]]; then
        log "⏭️  Skipping temporary-file cleanup."
        return
    fi

    log "🗑️  Cleaning temporary files..."
    for pattern in "${TEMP_PATTERNS[@]}"; do
        run_cmd "find \"$PROJECT_ROOT\" -type f -name '$pattern' -not -path '*/.git/*' -delete"
    done
}

run_maven_clean() {
    if [[ "$RUN_MAVEN_CLEAN" == false ]]; then
        log "⏭️  Skipping Maven clean."
        return
    fi

    log "📦 Running Maven clean..."
    run_cmd "cd \"$PROJECT_ROOT\" && mvn clean"
}

main() {
    parse_args "$@"

    log "🧹 Starting cleanup for API Ecommerce Bookanga"
    log "📋 Log file: ${LOG_FILE}"
    [[ "$DRY_RUN" == true ]] && log "ℹ️  Dry-run enabled (no files will be deleted)."

    choose_runtime_actions
    run_maven_clean
    cleanup_logs
    cleanup_temp_files

    log "✅ Cleanup complete!"
}

main "$@"
