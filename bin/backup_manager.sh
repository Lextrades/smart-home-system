#!/bin/bash

# Configuration
SYSTEM_ROOT="/home/jetson/smart-home-system"
BACKUP_BUFFER="${SYSTEM_ROOT}/backups/snapshot_buffer"
LOG_FILE="${SYSTEM_ROOT}/logs/backup.log"

HDD_MOUNT="/mnt/hdd"
HDD_TARGET_BASE="${HDD_MOUNT}/Backups/Jetson_2GB"
HDD_BACKUP_DIR="${HDD_TARGET_BASE}/backup"
HDD_LOG_DIR="${HDD_TARGET_BASE}/logs"

# Telegram Configuration
# Load secrets from web/.env if available
ENV_FILE="${SYSTEM_ROOT}/web/.env"
if [ -f "$ENV_FILE" ]; then
    # Source the file, ignoring comments/empty lines
    # We export them so they are available
    set -a
    source "$ENV_FILE"
    set +a
fi

# Fallback or Check
TELEGRAM_BOT_TOKEN="${TELEGRAM_BOT_TOKEN:-YOUR_BOT_TOKEN_HERE}"
TELEGRAM_CHAT_ID="${TELEGRAM_CHAT_ID:-YOUR_CHAT_ID_HERE}"

TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

# Helper Functions
log_message() {
    local msg="[$(date '+%Y-%m-%d %H:%M:%S')] $1"
    echo "$msg"
    echo "$msg" >> "$LOG_FILE"
}

send_notification() {
    local subject="$1"
    local message="$2"
    log_message "NOTIFICATION: $subject - $message"
    
    curl -s -X POST "https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage" \
        -d chat_id="${TELEGRAM_CHAT_ID}" \
        -d text="⚠️ *${subject}* ⚠️%0A${message}" \
        -d parse_mode="Markdown" > /dev/null
}

# --- START ---
mkdir -p "$(dirname "$LOG_FILE")"
log_message "=== Starting Backup Process ($TIMESTAMP) ==="

# 1. STRICT LOCAL BUFFER PHASE
# We sync everything to a local directory first. This ensures we have a backup 
# even if the HDD is missing.
log_message "Phase 1: Syncing to Local Buffer ($BACKUP_BUFFER)..."
mkdir -p "$BACKUP_BUFFER"

# Define what to backup
# 1. The Smart Home System Directory (Scripts, Web, Logs, Local Configs)
# 2. Key System Configs (/etc/nginx, /etc/letsencrypt, crontabs)
# Note: Requires ROOT/Sudo for /etc usually.

RSYNC_OPTS="-a --delete --no-o --no-g" 
# --no-o/g prevents permission errors if user mapping differs, 
# though running as root (recommended) makes this less critical.

# Sync Smart Home System (Excluding the backups folder itself to prevent loops!)
rsync $RSYNC_OPTS --exclude 'backups' "$SYSTEM_ROOT/" "$BACKUP_BUFFER/smart-home-system/"
if [ $? -eq 0 ]; then
    log_message "Local Buffer: Smart Home System synced."
else
    log_message "ERROR: Local Buffer Smart Home System sync failed!"
    send_notification "Backup Error" "Failed to sync system to local buffer."
    exit 1
fi

# Sync System Configs (Best effort)
mkdir -p "$BACKUP_BUFFER/system_etc"
rsync $RSYNC_OPTS /etc/nginx "$BACKUP_BUFFER/system_etc/" 2>/dev/null
rsync $RSYNC_OPTS /etc/letsencrypt "$BACKUP_BUFFER/system_etc/" 2>/dev/null
# Add more system paths here as needed

# 2. HDD OFFLOAD PHASE
log_message "Phase 2: Offloading to HDD..."

if mountpoint -q "$HDD_MOUNT"; then
    log_message "HDD detected at $HDD_MOUNT."
    
    mkdir -p "$HDD_BACKUP_DIR"
    mkdir -p "$HDD_LOG_DIR"
    
    CURRENT_BACKUP_PATH="${HDD_BACKUP_DIR}/backup_${TIMESTAMP}"
    LATEST_LINK="${HDD_BACKUP_DIR}/latest"
    
    # Use link-dest for efficient snapshots against the HDD's 'latest'
    HDD_RSYNC_OPTS="-a --delete"
    if [ -d "$LATEST_LINK" ]; then
        HDD_RSYNC_OPTS="$HDD_RSYNC_OPTS --link-dest=$LATEST_LINK"
    fi
    
    log_message "Syncing Buffer to HDD: $CURRENT_BACKUP_PATH"
    
    if rsync $HDD_RSYNC_OPTS "$BACKUP_BUFFER/" "$CURRENT_BACKUP_PATH/"; then
        log_message "HDD Backup Successful."
        
        # Update Symlink
        rm -f "$LATEST_LINK"
        ln -s "$CURRENT_BACKUP_PATH" "$LATEST_LINK"
        
        # Archive Log
        cp "$LOG_FILE" "$HDD_LOG_DIR/backup_${TIMESTAMP}.log"
        
        # Optional: Prune Local Buffer? 
        # No, we keep the buffer as the "latest on-device state".
        
    else
        log_message "CRITICAL: Sync to HDD failed."
        send_notification "Backup Failure" "Rsync to HDD failed even though mounted."
    fi

else
    log_message "WARNING: HDD NOT DETECTED at $HDD_MOUNT."
    log_message "Backup remains safely in Local Buffer: $BACKUP_BUFFER"
    send_notification "HDD Missing" "Backup completed to LOCAL BUFFER only. HDD was not found."
fi

log_message "=== Backup Complete ==="
