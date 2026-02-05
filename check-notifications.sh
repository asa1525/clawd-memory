#!/bin/bash
# 检查并发送通知脚本

LOG_DIR="/root/.openclaw/workspace"
LAST_CHECK_FILE="$LOG_DIR/.last-notify-check"

get_date() {
    date '+%Y-%m-%d'
}

# 获取昨天的日期
get_yesterday() {
    date -d "yesterday" '+%Y-%m-%d'
}

# 检查记忆备份
check_backup() {
    local yesterday=$(get_yesterday)
    local log_file="$LOG_DIR/backup.log"
    
    if [ -f "$log_file" ]; then
        if grep -q "\[$yesterday\].*✅ 已备份到 GitHub" "$log_file"; then
            echo "BACKUP_SUCCESS"
        elif grep -q "\[$yesterday\].*❌ 备份失败" "$log_file"; then
            grep "\[$yesterday\].*❌ 备份失败" "$log_file" | tail -1
        else
            echo "BACKUP_NONE"
        fi
    else
        echo "BACKUP_NO_LOG"
    fi
}

# 检查每周更新
check_weekly_update() {
    local last_friday=$(date -d "last Friday" '+%Y-%m-%d')
    local log_file="$LOG_DIR/weekly-update.log"
    
    if [ -f "$log_file" ]; then
        if grep -q "^\[$last_friday.*\]✅ OpenClaw 更新成功" "$log_file"; then
            echo "UPDATE_SUCCESS"
        elif grep -q "\[$last_friday.*\]❌.*更新失败" "$log_file"; then
            grep "\[$last_friday.*\]❌.*更新失败" "$log_file" | tail -1
        else
            echo "UPDATE_NONE"
        fi
    else
        echo "UPDATE_NO_LOG"
    fi
}

# 为主会话生成系统事件
generate_notification() {
    local backup_status=$(check_backup)
    local update_status=$(check_weekly_update)
    local today=$(get_date)
    
    # 检查是否已经发送过通知
    if [ -f "$LAST_CHECK_FILE" ]; then
        last_checked=$(cat "$LAST_CHECK_FILE")
        if [ "$last_checked" = "$today" ]; then
            exit 0
        fi
    fi
    
    # 生成通知
    local message=""
    
    # 备份通知
    case $backup_status in
        BACKUP_SUCCESS)
            message="$message✅ 昨晚记忆已自动备份到 GitHub\n"
            ;;
        BACKUP_NONE)
            message="$message📝 昨晚没有新内容需要备份\n"
            ;;
        *)
            message="$message⚠️ 昨晚备份状态异常: $backup_status\n"
            ;;
    esac
    
    # 更新通知 (只在周六检查)
    if [ "$(date '+%u')" = "6" ]; then
        case $update_status in
            UPDATE_SUCCESS)
                message="$message✅ 上周五已自动更新 OpenClaw 和 Skills\n"
                ;;
            UPDATE_NONE)
                message="$message📝 上周五没有可用更新\n"
                ;;
            UPDATE_FAIL|*)
                message="$message❌ 上周五更新失败，请检查日志\n"
                ;;
        esac
    fi
    
    if [ -n "$message" ]; then
        echo "$message"
        echo "$today" > "$LAST_CHECK_FILE"
    fi
}

generate_notification
