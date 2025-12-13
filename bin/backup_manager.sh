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

# --- START ---
mkdir -p "$(dirname "$LOG_FILE")"
log_message "=== Starting Backup Process ($TIMESTAMP) ==="

# Define Source Paths
SRC_SYSTEM="$SYSTEM_ROOT/"
SRC_PUBLIC="/mnt/hdd/public"

# Targets are defined dynamically below

if mountpoint -q "$HDD_MOUNT"; then
    log_message "✅ HDD Detected at $HDD_MOUNT. Performing DIRECT BACKUP."
    
    mkdir -p "$HDD_BACKUP_DIR"
    mkdir -p "$HDD_LOG_DIR"
    
    CURRENT_BACKUP_PATH="${HDD_BACKUP_DIR}/backup_${TIMESTAMP}"
    LATEST_LINK="${HDD_BACKUP_DIR}/latest"
    
    # 1. Prepare Snapshot Link-Dest
    HDD_RSYNC_OPTS="-a --delete"
    if [ -d "$LATEST_LINK" ]; then
        HDD_RSYNC_OPTS="$HDD_RSYNC_OPTS --link-dest=$LATEST_LINK"
    fi
    
    log_message "Target: $CURRENT_BACKUP_PATH"
    
    # 2. Sync Smart Home System (Direct to HDD)
    # We exclude 'backups' to avoid recursion, and 'node_modules' to save space/time/inodes
    mkdir -p "$CURRENT_BACKUP_PATH/smart-home-system"
    rsync $HDD_RSYNC_OPTS --exclude 'backups' --exclude 'node_modules' "$SRC_SYSTEM" "$CURRENT_BACKUP_PATH/smart-home-system/"
    
    # 3. Sync System Configs (Direct to HDD)
    mkdir -p "$CURRENT_BACKUP_PATH/system_etc"
    rsync $HDD_RSYNC_OPTS /etc/nginx "$CURRENT_BACKUP_PATH/system_etc/" 2>/dev/null
    rsync $HDD_RSYNC_OPTS /etc/letsencrypt "$CURRENT_BACKUP_PATH/system_etc/" 2>/dev/null
    
    # 4. Sync Public Web Content (HDD Live -> HDD Archive)
    if [ -d "$SRC_PUBLIC" ]; then
        mkdir -p "$CURRENT_BACKUP_PATH/hdd-public"
        rsync $HDD_RSYNC_OPTS "$SRC_PUBLIC/" "$CURRENT_BACKUP_PATH/hdd-public/"
        log_message "Public Content archived."
    fi
    
    # 5. Finalize
    if [ $? -eq 0 ]; then
        # Update Symlink
        rm -f "$LATEST_LINK"
        ln -s "$CURRENT_BACKUP_PATH" "$LATEST_LINK"
        
        log_message "HDD Backup SUCCESSFUL."
        # We don't send a Telegram message for every success to reduce noise, 
        # unless you want to uncomment the next line:
        # send_notification "Backup Success" "Direct HDD backup completed."
        
        # Log Maintenance
        cp "$LOG_FILE" "$HDD_LOG_DIR/backup_${TIMESTAMP}.log"
        
        # CLEANUP: Since we have a good HDD backup, we can (optionally) clean the local buffer 
        # to ensure SD card stays empty. 
        if [ -d "$BACKUP_BUFFER" ]; then
             rm -rf "$BACKUP_BUFFER"
             log_message "Maintenance: Local buffer cleared."
        fi
    else
        log_message "ERROR: Rsync reported errors."
        send_notification "Backup Error" "Rsync errors during HDD backup."
    fi

else
    # --- FALLBACK MODE (HDD MISSING) ---
    log_message "⚠️ WARNING: HDD NOT DETECTED at $HDD_MOUNT."
    log_message "Executing FALLBACK backup to Local Buffer ($BACKUP_BUFFER)."
    
    mkdir -p "$BACKUP_BUFFER"
    
    # RSYNC_OPTS for local (no hardlinks needed usually, just mirror)
    LOCAL_RSYNC_OPTS="-a --delete --no-o --no-g"
    
    # Sync System
    rsync $LOCAL_RSYNC_OPTS --exclude 'backups' --exclude 'node_modules' "$SRC_SYSTEM" "$BACKUP_BUFFER/smart-home-system/"
    
    if [ $? -eq 0 ]; then
        log_message "Local Buffer Sync: OK"
        send_notification "HDD Missing" "Backup performed to LOCAL SD CARD only. Please check HDD."
    else
        log_message "CRITICAL: Local Buffer Sync FAILED (Disk full?)"
        send_notification "Backup CRITICAL" "HDD missing AND Local SD card failed (full?). System unprotected."
    fi
fi

log_message "=== Backup Complete ==="
