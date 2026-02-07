#!/usr/bin/env bash
# watchdog-backup.sh — Cron 失败的兜底备份脚本
# 由 Watchdog 每60秒调用，只在 Cron 失败时执行
#
# 逻辑：
# 1. 检查上次 Cron 备份时间
# 2. 如果超过24小时且 Cron 失败，执行兜底备份
# 3. 不会和 Cron 同时执行

set -euo pipefail

# --- Config ---
STATE_DIR="${STATE_DIR:-/root/.openclaw/upgrade-guard}"
BACKUP_STATE="$STATE_DIR/backup-state.json"
MEMORY_BACKUP_DIR="${MEMORY_BACKUP_DIR:-/root/.openclaw/.memory-backup}"
BACKUP_INTERVAL="${BACKUP_INTERVAL:-86400}"  # 24小时

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

info()  { echo -e "${BLUE}[INFO]${NC} $*"; }
ok()    { echo -e "${GREEN}[OK]${NC} $*"; }
warn()  { echo -e "${YELLOW}[WARN]${NC} $*"; }
fail()  { echo -e "${RED}[FAIL]${NC} $*"; }

mkdir -p "$STATE_DIR"
mkdir -p "$MEMORY_BACKUP_DIR"

# ============================================================
# State management
# ============================================================
get_state() {
  if [[ -f "$BACKUP_STATE" ]]; then
    python3 -c "
import json, sys
with open('$BACKUP_STATE') as f:
    s = json.load(f)
print(s.get('${1}', '${2:-}'))
" 2>/dev/null || echo "${2:-}"
  else
    echo "${2:-}"
  fi
}

set_state() {
  local key="$1" value="$2"
  python3 -c "
import json, sys
f = open('$BACKUP_STATE') if os.path.exists('$BACKUP_STATE') else None
s = json.load(f) if f else {}
f.close() if f else None
s['$key'] = '$value'
with open('$BACKUP_STATE', 'w') as f:
    json.dump(s, f, indent=2)
" 2>/dev/null
}

# ============================================================
# Check if Cron backup ran today
# ============================================================
check_cron_backup() {
  local today
  today=$(date +%Y-%m-%d)
  
  # 检查 memory 备份的修改时间
  if [[ -f "/root/.openclaw/workspace/memory/$(date +%Y-%m-%d).md" ]]; then
    return 0  # Cron 今天创建了日记文件
  fi
  
  # 检查 memory 目录修改时间
  if [[ -d "/root/.openclaw/workspace/memory" ]]; then
    local mem_mtime
    mem_mtime=$(stat -c %Y /root/.openclaw/workspace/memory 2>/dev/null || echo "0")
    local today_start
    today_start=$(date -d "today 00:00:00" +%s 2>/dev/null || echo "0")
    if [[ "$mem_mtime" -ge "$today_start" ]]; then
      return 0
    fi
  fi
  
  return 1
}

# ============================================================
# Execute backup (same as backup-memory.sh)
# ============================================================
execute_backup() {
  local ts
  ts=$(date +%Y%m%d-%H%M%S)
  local backup_file="$MEMORY_BACKUP_DIR/memory-backup-${ts}.tar.gz"
  
  info "Watchdog backup triggered (Cron may have failed)..."
  
  # 备份 memory 目录
  cd /root/.openclaw/workspace
  tar -czf "$backup_file" memory/ MEMORY.md 2>/dev/null
  
  if [[ -f "$backup_file" ]]; then
    ok "Backup created: $backup_file"
    
    # 记录状态
    set_state "last_backup_time" "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
    set_state "last_backup_file" "$backup_file"
    set_state "backup_type" "watchdog"
    
    # 清理旧备份（保留7天）
    find "$MEMORY_BACKUP_DIR" -name "*.tar.gz" -mtime +7 -delete 2>/dev/null || true
    
    return 0
  else
    fail "Backup failed!"
    return 1
  fi
}

# ============================================================
# Main logic
# ============================================================
main() {
  local cron_ran_today=false
  
  # 1. 检查 Cron 今天是否执行了备份
  if check_cron_backup; then
    ok "Cron backup ran today - no action needed"
    cron_ran_today=true
  else
    warn "Cron backup may have failed - checking timestamp..."
  fi
  
  # 2. 检查距离上次备份的时间
  local last_backup
  last_backup=$(get_state "last_backup_time" "0")
  local now
  now=$(date +%s)
  
  if [[ "$last_backup" != "0" ]]; then
    local last_epoch
    last_epoch=$(date -d "$last_backup" +%s 2>/dev/null || echo "0")
    local elapsed=$((now - last_epoch))
    local interval=${BACKUP_INTERVAL:-86400}
    
    if [[ "$elapsed" -lt "$interval" ]]; then
      info "Last backup was ${elapsed}s ago (interval: ${interval}s) - no action needed"
      return 0
    fi
  fi
  
  # 3. 只有在 Cron 没执行时才执行兜底备份
  if [[ "$cron_ran_today" == "false" ]]; then
    warn "Cron backup missed today - executing watchdog backup..."
    execute_backup
  else
    info "Cron backup is healthy - watchdog doing nothing"
  fi
}

# Run main
main
