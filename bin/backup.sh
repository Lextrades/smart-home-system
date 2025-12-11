#!/bin/bash
set -e

BACKUP_DIR="/mnt/hdd/Backups/Jetson_2GB"
DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="$BACKUP_DIR/jetson_backup_$DATE.tar.gz"

# Ensure backup directory exists
mkdir -p "$BACKUP_DIR"

echo "Starting backup to $BACKUP_FILE..."

# Create archive
# We use sudo to ensure we can read all files (like /etc/cloudflared)
sudo tar -czf "$BACKUP_FILE" \
    /home/jetson/.cloudflared \
    /home/jetson/.ssh \
    /home/jetson/monitoring \
    /etc/cloudflared \
    /etc/nginx/sites-available \
    /var/www/dev \
    --warning=no-file-changed

echo "Backup created successfully."

# Cleanup old backups (keep last 7 days)
echo "Cleaning up old backups..."
find "$BACKUP_DIR" -name "jetson_backup_*.tar.gz" -mtime +7 -delete

echo "Backup process complete."
ls -lh "$BACKUP_FILE"
