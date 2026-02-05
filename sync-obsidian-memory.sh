#!/bin/bash
# Obsidian → Memory 同步脚本

echo "=== $(date) 开始同步 ==="

# 1. 查找最新的笔记
LATEST_NOTE=$(find ~/.openclaw/workspace/storage/vault/u_1/note -name "content.txt" -type f -mmin -1440 2>/dev/null | head -5)

if [ -z "$LATEST_NOTE" ]; then
    echo "没有找到新笔记（24小时内）"
    exit 0
fi

# 2. 读取最新笔记内容
echo "=== 最新笔记 ===" > /tmp/obsidian_update.md
echo "更新时间: $(date)" >> /tmp/obsidian_update.md
echo "" >> /tmp/obsidian_update.md

for note in $LATEST_NOTE; do
    CONTENT=$(cat "$note" 2>/dev/null)
    if [ -n "$CONTENT" ]; then
        echo "---" >> /tmp/obsidian_update.md
        echo "## $(basename $(dirname $note))" >> /tmp/obsidian_update.md
        echo "$CONTENT" >> /tmp/obsidian_update.md
    fi
done

# 3. 追加到 MEMORY.md
echo "" >> ~/.openclaw/workspace/MEMORY.md
echo "## $(date +%Y-%m-%d) - 从 Obsidian 同步" >> ~/.openclaw/workspace/MEMORY.md
cat /tmp/obsidian_update.md >> ~/.openclaw/workspace/MEMORY.md

# 4. 同步到 GitHub
cd ~/.openclaw/workspace
git add MEMORY.md 2>/dev/null
git commit -m "Obsidian sync $(date +%Y-%m-%d)" 2>/dev/null

echo "=== 同步完成 ==="
