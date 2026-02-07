#!/bin/bash
# 每日记忆备份脚本 - 使用 SSH 认证

BACKUP_DIR="/root/.openclaw/workspace"
LOG_FILE="/root/.openclaw/workspace/backup.log"

cd "$BACKUP_DIR"

# 配置 git
git config user.email "poonpan0710@gmail.com" 2>/dev/null
git config user.name "DNLM" 2>/dev/null

# 确保使用 SSH 认证
git remote set-url origin git@github.com:asa1525/clawd-memory.git 2>/dev/null

# 拉取远程最新
git fetch origin

# 获取本地和远程的 commit 数
LOCAL=$(git rev-parse @)
REMOTE=$(git rev-parse @{u})

if [ "$LOCAL" = "$REMOTE" ]; then
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] 没有新内容需要备份" >> "$LOG_FILE"
else
    # 有新内容，添加并推送
    git add -A
    if git commit -m "自动备份 $(date '+%Y-%m-%d %H:%M')" && git push origin main 2>&1; then
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] ✅ 已备份到 GitHub" >> "$LOG_FILE"
    else
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] ❌ 备份失败" >> "$LOG_FILE"
    fi
fi
