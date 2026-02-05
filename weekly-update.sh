#!/bin/bash
# 每周五更新 OpenClaw + Skills（带完整日志和通知）

SKILLS_DIR="$HOME/.claude/skills"
BACKUP_DIR="$HOME/.claude/skills-backup"
LOG_FILE="/root/.openclaw/workspace/weekly-update.log"

mkdir -p "$BACKUP_DIR"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

log "========================================"
log "🚀 开始每周更新 (周五)"
log "========================================"

# 1. 更新 Skills
log ""
log "📦 更新 Skills..."

update_skill() {
    local skill_path="$1"
    local skill_name=$(basename "$skill_path")
    local status="success"
    
    log "  🔄 $skill_name"
    
    # 备份
    local backup_path="$BACKUP_DIR/${skill_name}-$(date '+%Y%m%d-%H%M%S')"
    cp -r "$skill_path" "$backup_path" 2>/dev/null
    
    if [ -d "$skill_path/.git" ]; then
        cd "$skill_path"
        if git fetch origin main 2>/dev/null; then
            local local_commit=$(git rev-parse HEAD 2>/dev/null)
            local remote_commit=$(git rev-parse origin/main 2>/dev/null)
            
            if [ "$local_commit" != "$remote_commit" ]; then
                if ! git pull origin main 2>&1 | tee -a "$LOG_FILE"; then
                    log "    ❌ 更新失败，回滚..."
                    rm -rf "$skill_path"
                    mv "$backup_path" "$skill_path"
                    status="rollback"
                else
                    log "    ✅ 已更新"
                fi
            else
                log "    ✅ 已是最新"
            fi
        else
            log "    ⚠️  无法连接"
            status="network_error"
        fi
    else
        log "    ⚠️  无 git 仓库"
        status="no_git"
    fi
    
    echo "$skill_name:$status"
}

success_count=0
fail_count=0
skip_count=0

for skill in "$SKILLS_DIR"/*/; do
    if [ -d "$skill" ]; then
        result=$(update_skill "$skill")
        skill_name=$(echo "$result" | cut -d: -f1)
        status=$(echo "$result" | cut -d: -f2)
        
        case $status in
            success) ((success_count++)) ;;
            rollback|fail) ((fail_count++)) ;;
            *) ((skip_count++)) ;;
        esac
    fi
done

# 2. 更新 OpenClaw
log ""
log "🔄 更新 OpenClaw..."
if [ -f /root/.openclaw/workspace/update-openclaw.sh ]; then
    if /root/.openclaw/workspace/update-openclaw.sh >> "$LOG_FILE" 2>&1; then
        log "  ✅ OpenClaw 更新成功"
    else
        log "  ❌ OpenClaw 更新失败，请检查日志"
        fail_count=$((fail_count + 1))
    fi
fi

# 3. 生成通知消息
log ""
log "========================================"
log "📊 更新完成"
log "   Skills 成功: $success_count"
log "   Skills 失败: $fail_count"
log "   Skills 跳过: $skip_count"
log "========================================"

# 生成通知内容
if [ $fail_count -eq 0 ]; then
    echo "SUCCESS:$success_count:$skip_count:0"
else
    echo "FAIL:$success_count:$skip_count:$fail_count"
fi
