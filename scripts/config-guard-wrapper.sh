#!/usr/bin/env bash
# config-guard-wrapper.sh — Config Guard wrapper with backup retention policy
# Usage: Same as config-guard.sh
# Features:
#   - Uses /root/.openclaw/openclaw.json as default config
#   - Keeps only the last 10 backups
#   - All other functions same as config-guard.sh

set -euo pipefail

# Config path with workspace default
CONFIG_PATH="${2:-/root/.openclaw/openclaw.json}"
BACKUP_DIR="/root/.openclaw/.config-backups"
KEEP_BACKUPS=10

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

log()  { echo -e "${GREEN}[config-guard]${NC} $*"; }
warn() { echo -e "${YELLOW}[config-guard]${NC} $*"; }
fail() { echo -e "${RED}[config-guard]${NC} $*" && exit "${2:-1}"; }

# ── Cleanup old backups (keep only KEEP_BACKUPS) ───────────────────
cleanup_old_backups() {
    local count
    count=$(find "$BACKUP_DIR" -name "openclaw-*.json" 2>/dev/null | wc -l)
    if [[ $count -gt $KEEP_BACKUPS ]]; then
        local to_remove=$((count - KEEP_BACKUPS))
        find "$BACKUP_DIR" -name "openclaw-*.json" -type f -printf '%T+ %p\n' 2>/dev/null | \
            sort | head -n "$to_remove" | while read -r line; do
                rm -f "$(echo "$line" | cut -d' ' -f2-)"
            done
        log "Cleaned up old backups (keeping last $KEEP_BACKUPS)"
    fi
}

# ── Enhanced backup with cleanup ─────────────────────────────────────
backup_with_cleanup() {
    mkdir -p "$BACKUP_DIR"
    local ts
    ts=$(date +%Y%m%d-%H%M%S)
    local backup_file="$BACKUP_DIR/openclaw-${ts}.json"
    cp "$CONFIG_PATH" "$backup_file"
    ln -sf "$backup_file" "$BACKUP_DIR/latest.json"
    log "Backed up to $backup_file"
    cleanup_old_backups
    echo "$backup_file"
}

# ── Main logic ─────────────────────────────────────────────────────
case "${1:-check}" in
    check)
        log "Validating $CONFIG_PATH..."
        bash /root/.openclaw/workspace/config-guard/scripts/config-guard.sh check "$CONFIG_PATH"
        ;;
    apply)
        log "Backing up config..."
        backup_with_cleanup
        log "Validating config..."
        bash /root/.openclaw/workspace/config-guard/scripts/config-guard.sh check "$CONFIG_PATH"
        log "Config validated — ready to apply manually"
        log "Run: bash /root/.openclaw/workspace/scripts/config-guard.sh apply-restart $CONFIG_PATH"
        ;;
    apply-restart)
        log "Backing up config..."
        backup_with_cleanup
        log "Validating config..."
        bash /root/.openclaw/workspace/config-guard/scripts/config-guard.sh check "$CONFIG_PATH" || exit 1
        log "Config validated — applying changes..."
        bash /root/.openclaw/workspace/config-guard/scripts/config-guard.sh apply "$CONFIG_PATH"
        ;;
    diff)
        bash /root/.openclaw/workspace/config-guard/scripts/config-guard.sh diff "$CONFIG_PATH"
        ;;
    rollback)
        bash /root/.openclaw/workspace/config-guard/scripts/config-guard.sh rollback "$CONFIG_PATH"
        ;;
    list-backups)
        log "Config backups (keeping last $KEEP_BACKUPS):"
        ls -lt "$BACKUP_DIR"/openclaw-*.json 2>/dev/null | head -20 || warn "No backups found"
        ;;
    *)
        echo "Usage: $0 {check|apply|apply-restart|diff|rollback|list-backups} [config-path]"
        echo ""
        echo "Commands:"
        echo "  check          — Validate config without applying"
        echo "  apply          — Backup → validate → show diff (ready to apply)"
        echo "  apply-restart  — Backup → validate → apply → verify (full safe apply)"
        echo "  diff           — Show what changed vs backup"
        echo "  rollback       — Restore from latest backup"
        echo "  list-backups   — List available backups"
        exit 1
        ;;
esac
