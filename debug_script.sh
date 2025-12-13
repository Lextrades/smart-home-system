#!/bin/bash
OUTPUT_FILE=~/smart-home-system/debug_diag.txt
{
    echo "=== DISK USAGE ==="
    df -h
    echo "=== INODES ==="
    df -i
    echo "=== DIRECTORY PERMISSIONS ==="
    ls -ld ~/smart-home-system
    ls -ld ~/smart-home-system/backups
    ls -ld ~/smart-home-system/backups/snapshot_buffer
    echo "=== LOCAL RSYNC TEST ==="
    mkdir -p ~/smart-home-system/backups/snapshot_buffer
    rsync -avn --exclude 'backups' ~/smart-home-system/ ~/smart-home-system/backups/snapshot_buffer/smart-home-system/
} > "$OUTPUT_FILE" 2>&1
