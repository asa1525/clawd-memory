#!/bin/bash
# OpenClaw 更新脚本（带备份）

LOG_FILE="/root/.openclaw/workspace/update-openclaw.log"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
    echo "$1"
}

# 备份当前版本
BACKUP_DIR="/root/.openclaw/backup/openclaw-$(date '+%Y%m%d-%H%M%S')"
log "📦 备份 OpenClaw 到 $BACKUP_DIR"
mkdir -p "$BACKUP_DIR"
cp -r /usr/lib/node_modules/openclaw "$BACKUP_DIR/" 2>/dev/null || true

# 更新 OpenClaw
log "🔄 开始更新 OpenClaw..."
cd /usr/lib/node_modules/openclaw

# 检查是否有 git
if [ -d ".git" ]; then
    git fetch origin
    if git pull origin main 2>&1 | tee -a "$LOG_FILE"; then
        log "✅ OpenClaw 更新成功"
    else
        log "❌ OpenClaw 更新失败，开始回滚..."
        rm -rf /usr/lib/node_modules/openclaw
        mv "$BACKUP_DIR/openclaw" /usr/lib/node_modules/openclaw
        log "🔄 已回滚"
        exit 1
    fi
else
    log "⚠️  没有 git 仓库，跳过更新"
fi

# 重启服务
log "🔄 重启 OpenClaw 服务..."
if openclaw gateway restart 2>&1 | tee -a "$LOG_FILE"; then
    log "✅ OpenClaw 已重启"
else
    log "⚠️  重启命令不可用，服务将在下次启动时生效"
fi

log "========================================"
