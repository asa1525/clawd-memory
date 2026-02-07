#!/usr/bin/env bash
# watchdog-wrapper.sh — OS-level gateway watchdog with auto-recovery
# Runs independently of the AI agent and gateway via systemd timer.
#
# Recovery strategy:
#   - Failures 1-2 → log and wait
#   - Failure 3+ → restart gateway
#   - Failure 6+ → full rollback to last snapshot
#
# Usage:
#   watchdog.sh check      # Single health check (for cron/timer)
#   watchdog.sh install    # Install systemd timer (runs every 60s)
#   watchdog.sh uninstall  # Remove systemd timer
#   watchdog.sh status     # Show watchdog state

set -euo pipefail

# Config with workspace defaults
OPENCLAW_DIR="${OPENCLAW_DIR:-/opt/clawdbot}"
CONFIG_FILE="${CONFIG_FILE:-/root/.openclaw/openclaw.json}"
STATE_DIR="${STATE_DIR:-/root/.openclaw/upgrade-guard}"
WATCHDOG_STATE="$STATE_DIR/watchdog-state.json"
GATEWAY_PORT="${GATEWAY_PORT:-18789}"
GATEWAY_URL="http://127.0.0.1:${GATEWAY_PORT}"
FAIL_THRESHOLD="${FAIL_THRESHOLD:-3}"
RESTART_TIMEOUT="${RESTART_TIMEOUT:-60}"
UPGRADE_GUARD="/root/.openclaw/workspace/scripts/upgrade-guard.sh"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

info()  { echo -e "${BLUE}ℹ${NC} $*"; }
ok()    { echo -e "${GREEN}✔${NC} $*"; }
warn()  { echo -e "${YELLOW}⚠${NC} $*"; }
fail()  { echo -e "${RED}✖${NC} $*"; }

mkdir -p "$STATE_DIR"

# Forward to original script
case "${1:-check}" in
    check)
        bash /root/.openclaw/workspace/upgrade-guard/scripts/watchdog.sh check
        
        # 执行兜底备份检查（如果 Cron 失败）
        # 只在健康检查成功时执行，避免在系统不稳定时做备份
        if [[ $? -eq 0 ]]; then
          bash /root/.openclaw/workspace/scripts/watchdog-backup.sh 2>&1 | grep -E "^\[|\[OK\]|\[WARN\]|\[FAIL\]" || true
        fi
        ;;
    install)
        bash /root/.openclaw/workspace/upgrade-guard/scripts/watchdog.sh install
        ;;
    uninstall)
        bash /root/.openclaw/workspace/upgrade-guard/scripts/watchdog.sh uninstall
        ;;
    status)
        bash /root/.openclaw/workspace/upgrade-guard/scripts/watchdog.sh status
        ;;
    *)
        echo "Usage: $0 {check|install|uninstall|status}"
        echo ""
        echo "Commands:"
        echo "  check      — Single health check (for cron/timer)"
        echo "  install   — Install systemd timer (runs every 60s)"
        echo "  uninstall — Remove systemd timer"
        echo "  status    — Show watchdog state"
        exit 1
        ;;
esac
