#!/bin/bash

# Configuration
BASE_DIR="$HOME/smart-home-system"
BACKUP_BUFFER="${BASE_DIR}/backups"
BIN_DIR="${BASE_DIR}/bin"
CONFIG_DIR="${BASE_DIR}/config"
WEB_DIR="${BASE_DIR}/web"
LOG_DIR="${BASE_DIR}/logs"

# Color codes
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_err() { echo -e "${RED}[ERROR]${NC} $1"; }

log_info "Starting migration to Smart Home System structure..."

# 1. Create Directory Structure
log_info "Creating directories in $BASE_DIR..."
mkdir -p "$BACKUP_BUFFER"
mkdir -p "$BIN_DIR"
mkdir -p "$CONFIG_DIR"
mkdir -p "$WEB_DIR"
mkdir -p "$LOG_DIR"

# 2. Move Scripts to bin/
log_info "Moving scripts to $BIN_DIR..."
# Move all .sh files from Home, excluding this migration script if it's there
find "$HOME" -maxdepth 1 -name "*.sh" -not -name "migrate_system.sh" -exec mv {} "$BIN_DIR/" \;

# Move scripts from jetson-osx if they exist and are newer/relevant
# (Optional: Adjust based on user preference, but we'll safeguard)
if [ -d "$HOME/jetson-osx" ]; then
    log_info "Moving relevant scripts from ~/jetson-osx..."
    # Only move if destination does not exist (prevent overwriting new scripts)
    if [ ! -f "$BIN_DIR/backup_manager.sh" ]; then
        mv "$HOME/jetson-osx/backup_manager.sh" "$BIN_DIR/" 2>/dev/null
    fi
fi

# 3. Move Web Platform
log_info "Moving web platform to $WEB_DIR..."
if [ -d "$HOME/web_platform" ]; then
    mv "$HOME/web_platform/"* "$WEB_DIR/" 2>/dev/null
    rmdir "$HOME/web_platform" 2>/dev/null
elif [ -d "$HOME/jetson-osx/web_platform" ]; then
     mv "$HOME/jetson-osx/web_platform/"* "$WEB_DIR/" 2>/dev/null
fi

# 4. Move Git and Workspaces
log_info "Moving repositories..."
if [ -d "$HOME/git" ]; then
    mv "$HOME/git" "$BASE_DIR/"
fi
if [ -d "$HOME/b7s_workspace" ]; then
    mv "$HOME/b7s_workspace" "$BASE_DIR/"
fi

# 5. Handle Configs (Soft checks)
log_info "Setting up config references..."
# We don't move /etc files, but we can copy existing custom configs if found locally
if [ -f "$HOME/nginx.conf" ]; then mv "$HOME/nginx.conf" "$CONFIG_DIR/"; fi

# 5. Set Permissions
log_info "Setting permissions..."
chmod +x "$BIN_DIR"/*.sh

# 6. Cleanup
log_info "Migration complete."
log_info "New structure:"
tree -L 2 "$BASE_DIR" || ls -R "$BASE_DIR"

log_info "IMPORTANT: Please update your crontab to point to: $BIN_DIR/backup_manager.sh"
