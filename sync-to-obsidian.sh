#!/bin/bash
# OpenClaw → Obsidian 反向同步
# 笔记以日期命名（YYYY-MM-DD）

TODAY=$(date +%Y-%m-%d)
NOTE_TITLE="$1"

if [ -z "$NOTE_TITLE" ]; then
    echo "用法: ./sync-to-obsidian.sh '工作内容'"
    exit 1
fi

# 构建内容（标题为日期）
CONTENT="# $TODAY

$NOTE_TITLE

## 记录时间
$(date '+%Y-%m-%d %H:%M:%S')"

# 路径
NOTE_DIR=~/.openclaw/workspace/storage/vault/u_1/note

# 找到下一个可用编号
NEXT_NUM=1
while [ -d "$NOTE_DIR/n_$NEXT_NUM" ]; do
    NEXT_NUM=$((NEXT_NUM + 1))
done

# 创建笔记
NOTE_PATH="$NOTE_DIR/n_$NEXT_NUM"
mkdir -p "$NOTE_PATH"

# 写入内容
echo "$CONTENT" > "$NOTE_PATH/content.txt"
echo "$CONTENT" > "$NOTE_PATH/snapshot.txt"

# 更新 setting
SETTING_DIR=~/.openclaw/workspace/storage/vault/u_1/setting
mkdir -p "$SETTING_DIR"
cat > "$SETTING_DIR/n_$NEXT_NUM" << SETTING
{
  "created": $(date +%s),
  "updated": $(date +%s),
  "pined": false,
  "tags": [],
  "title": "$TODAY"
}
SETTING

echo "✅ 已创建笔记"
echo "   编号: n_$NEXT_NUM"
echo "   标题: $TODAY"
echo "   内容摘要: ${NOTE_TITLE:0:50}..."
