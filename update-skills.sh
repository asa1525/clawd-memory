#!/bin/bash
# 安全更新所有手动安装的 Skills（带备份和回滚）

SKILLS_DIR="$HOME/.claude/skills"
BACKUP_DIR="$HOME/.claude/skills-backup"
LOG_FILE="$HOME/.claude/skills-update.log"

# 创建备份目录
mkdir -p "$BACKUP_DIR"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

update_skill() {
    local skill_path="$1"
    local skill_name=$(basename "$skill_path")
    
    log "🔄 开始更新: $skill_name"
    
    # 1. 备份当前版本
    local backup_path="$BACKUP_DIR/${skill_name}-$(date '+%Y%m%d-%H%M%S')"
    cp -r "$skill_path" "$backup_path"
    log "  📦 已备份到: $backup_path"
    
    # 2. 检查是否有 .git 目录
    if [ ! -d "$skill_path/.git" ]; then
        log "  ⚠️  没有 git 仓库，跳过"
        return 0
    fi
    
    # 3. 尝试更新
    cd "$skill_path"
    if git fetch origin main 2>/dev/null; then
        local local_commit=$(git rev-parse HEAD)
        local remote_commit=$(git rev-parse origin/main)
        
        if [ "$local_commit" = "$remote_commit" ]; then
            log "  ✅ 已是最新版本"
        else
            if git pull origin main 2>&1 | tee -a "$LOG_FILE"; then
                log "  ✅ 更新成功"
            else
                log "  ❌ 更新失败，开始回滚..."
                rm -rf "$skill_path"
                mv "$backup_path" "$skill_path"
                log "  🔄 已回滚到备份版本"
                return 1
            fi
        fi
    else
        log "  ⚠️  无法连接到远程仓库"
    fi
    
    return 0
}

# 主程序
log "========================================"
log "🚀 开始更新 Skills"
log "========================================"

success_count=0
fail_count=0

for skill in "$SKILLS_DIR"/*/; do
    if [ -d "$skill" ]; then
        if update_skill "$skill"; then
            ((success_count++))
        else
            ((fail_count++))
        fi
    fi
done

log "========================================"
log "📊 更新完成"
log "   成功: $success_count"
log "   失败: $fail_count"
log "   备份位置: $BACKUP_DIR"
log "========================================"

# 清理 7 天前的旧备份
find "$BACKUP_DIR" -type d -mtime +7 -exec rm -rf {} \; 2>/dev/null
log "🧹 已清理 7 天前的旧备份"

echo ""
echo "✅ 更新完成！"
echo "   成功: $success_count | 失败: $fail_count"
echo "   备份位置: $BACKUP_DIR"
echo "   日志位置: $LOG_FILE"
