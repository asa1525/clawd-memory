#!/bin/bash
# Fast Note Sync Auto-Uploader
# Detects new notes and uploads them to Fast Note Sync server

# Configuration
STORAGE_DIR="$HOME/.openclaw/workspace/storage/vault/u_1/note"
API_URL="http://127.0.0.1:9000/api"
TOKEN_FILE="$HOME/.openclaw/workspace/.fastnote_token"
VAULT="u_1"

# Get or refresh token
get_token() {
    if [ -f "$TOKEN_FILE" ]; then
        cat "$TOKEN_FILE"
    else
        echo "No token found. Please login first."
        exit 1
    fi
}

# Ensure vault exists
ensure_vault() {
    local token=$1
    response=$(curl -s -X GET "${API_URL}/vault" \
        -H "Authorization: Bearer $token" \
        -H "Content-Type: application/json")
    
    if echo "$response" | grep -q "Vault does not exist"; then
        echo "Creating vault..."
        curl -s -X POST "${API_URL}/vault" \
            -H "Authorization: Bearer $token" \
            -H "Content-Type: application/json" \
            -d "{\"vault\":\"${VAULT}\",\"description\":\"Auto-created vault\"}" > /dev/null
    fi
}

# Upload a single note
upload_note() {
    local note_dir=$1
    local token=$2
    local note_name=$(basename "$note_dir")
    local content_file="${note_dir}/content.txt"
    
    if [ ! -f "$content_file" ]; then
        return
    fi
    
    local title=$(head -1 "$content_file" | sed 's/^# //')
    local content=$(cat "$content_file")
    
    # Check if note already exists
    local check_response=$(curl -s -X GET "${API_URL}/notes?vault=${VAULT}&limit=1" \
        -H "Authorization: Bearer $token" \
        -H "Content-Type: application/json")
    
    if echo "$check_response" | grep -q "\"path\":\"${note_name}\""; then
        echo "⏭️  Skipped (already exists): $note_name"
        return
    fi
    
    # Upload note
    local response=$(curl -s -X POST "${API_URL}/note" \
        -H "Authorization: Bearer $token" \
        -H "Content-Type: application/json" \
        -d "{\"vault\":\"${VAULT}\",\"path\":\"${note_name}\",\"title\":\"${title}\",\"content\":\"${content}\"}")
    
    if echo "$response" | grep -q '"status":true'; then
        echo "✅ Synced: $note_name"
    else
        echo "❌ Failed: $note_name - $response"
    fi
}

# Main sync logic
main() {
    local token=$(get_token)
    
    # Ensure vault exists
    ensure_vault "$token"
    
    echo "🔄 Scanning for new notes..."
    
    # Find and upload new notes
    for note_dir in "${STORAGE_DIR}"/n_*; do
        if [ -d "$note_dir" ]; then
            upload_note "$note_dir" "$token"
        fi
    done
    
    echo "✨ Sync complete!"
}

main
