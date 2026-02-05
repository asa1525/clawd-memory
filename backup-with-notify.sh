#!/bin/bash
# 每日记忆备份 + 通知脚本

BACKUP_SCRIPT="/root/.openclaw/workspace/backup-memory.sh"
LOG_FILE="/root/.openclaw/workspace/backup.log"

# 执行备份
$BACKUP_SCRIPT

# 检查备份结果
if grep -q "✅ 已备份到 GitHub" "$LOG_FILE" 2>/dev/null; then
    # 发送成功通知
    echo "备份成功，发送通知中..."
elif grep -q "❌ 备份失败" "$LOG_FILE" 2>/dev/null; then
    echo "备份失败"
fi
