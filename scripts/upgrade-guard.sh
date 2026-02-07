#!/usr/bin/env bash
# upgrade-guard-wrapper.sh — Upgrade Guard wrapper with state management
# Usage: Same as upgrade-guard.sh
# Features:
#   - Uses /root/.openclaw/openclaw.json as default config
#   - State directory: /root/.openclaw/upgrade-guard
#   - All other functions same as upgrade-guard.sh

set -euo pipefail

# Config with workspace defaults
OPENCLAW_DIR="${OPENCLAW_DIR:-/opt/clawdbot}"
CONFIG_FILE="${CONFIG_FILE:-/root/.openclaw/openclaw.json}"
STATE_DIR="${STATE_DIR:-/root/.openclaw/upgrade-guard}"
GATEWAY_URL="${GATEWAY_URL:-http://127.0.0.1:18789}"

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
case "${1:-snapshot}" in
    snapshot)
        bash /root/.openclaw/workspace/upgrade-guard/scripts/upgrade-guard.sh snapshot
        ;;
    check)
        bash /root/.openclaw/workspace/upgrade-guard/scripts/upgrade-guard.sh check
        ;;
    upgrade)
        shift
        bash /root/.openclaw/workspace/upgrade-guard/scripts/upgrade-guard.sh upgrade "$@"
        ;;
    verify)
        bash /root/.openclaw/workspace/upgrade-guard/scripts/upgrade-guard.sh verify
        ;;
    rollback)
        bash /root/.openclaw/workspace/upgrade-guard/scripts/upgrade-guard.sh rollback
        ;;
    status)
        bash /root/.openclaw/workspace/upgrade-guard/scripts/upgrade-guard.sh status
        ;;
    dry-run)
        bash /root/.openclaw/workspace/upgrade-guard/scripts/upgrade-guard.sh upgrade --dry-run
        ;;
    *)
        echo "Usage: $0 {snapshot|check|upgrade|verify|rollback|status|dry-run}"
        echo ""
        echo "Commands:"
        echo "  snapshot     — Save current state (version, config, plugins, deps)"
        echo "  check        — Pre-flight validation"
        echo "  upgrade      — Full safe upgrade (auto-rollback on failure)"
        echo "  upgrade --dry-run — Preview without changing anything"
        echo "  verify       — Post-upgrade verification"
        echo "  rollback     — Emergency restore to last snapshot"
        echo "  status       — Show current state vs snapshots"
        exit 1
        ;;
esac
