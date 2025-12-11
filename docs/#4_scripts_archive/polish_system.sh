#!/bin/bash

BASE_DIR="$HOME/smart-home-system"
BIN_DIR="${BASE_DIR}/bin"
GIT_DIR="${BASE_DIR}/git"

echo "Starting System Polish..."

# 1. Cleanup Old Logs and Buffers
echo "1. Removing old logs and buffers..."
rm -f "$HOME/backup.log"
rm -f "$HOME/login.log"
rm -rf "$HOME/backup_buffer"

# 2. Fix Git Repository Name and Hooks
OLD_GIT="$GIT_DIR/jetson-osx.git"
NEW_GIT="$GIT_DIR/smart-home-system.git"

if [ -d "$OLD_GIT" ]; then
    echo "2. Renaming Git repository to smart-home-system.git..."
    mv "$OLD_GIT" "$NEW_GIT"
    
    # Fix the post-receive hook to point to the new work tree
    HOOK_FILE="$NEW_GIT/hooks/post-receive"
    if [ -f "$HOOK_FILE" ]; then
        echo "   Updating git post-receive hook..."
        # Replace old path with new path
        sed -i 's|/home/jetson/jetson-osx|/home/jetson/smart-home-system|g' "$HOOK_FILE"
        echo "   Hook updated."
    fi
else
    echo "2. Git repo already renamed or missing."
fi

# 3. Organize Loose Root Files
echo "3. Organizing loose files into ~/smart-home-system/installers..."
mkdir -p "$BASE_DIR/installers"
mv "$HOME/b7s.tar.gz" "$BASE_DIR/installers/" 2>/dev/null
mv "$HOME/b7s.yaml" "$BASE_DIR/installers/" 2>/dev/null
mv "$HOME/bls-runtime" "$BASE_DIR/installers/" 2>/dev/null
mv "$HOME/get-docker.sh" "$BASE_DIR/installers/" 2>/dev/null
mv "$HOME/e2fsprogs"* "$BASE_DIR/installers/" 2>/dev/null
mv "$HOME/n8n-stack.yml" "$BASE_DIR/installers/" 2>/dev/null
mv "$HOME/cookie.txt" "$BASE_DIR/installers/" 2>/dev/null

echo "4. Checking Telegram Notification Logic..."
# We can't auto-test this easily without unmounting, but we confirm the script has it.
grep -q "send_notification" "$BIN_DIR/backup_manager.sh" && echo "   Notification logic present."

echo "=== Polish Complete ==="
echo "Your home directory should now be very clean."
ls -lh "$HOME"
