#!/bin/bash
set -e

NEW_SWAP="/mnt/hdd/swapfile"
OLD_SWAP="/swapfile"
SIZE="16G"

echo "=== Moving Swap to External Drive ==="

# 1. Create new swap file
if [ -f "$NEW_SWAP" ]; then
    echo "Swap file $NEW_SWAP already exists. Skipping creation."
else
    echo "Allocating $SIZE swap file at $NEW_SWAP (using dd, this will take a while)..."
    sudo dd if=/dev/zero of=$NEW_SWAP bs=1G count=16 status=progress
    sudo chmod 600 $NEW_SWAP
    sudo mkswap $NEW_SWAP
fi

# 2. Enable new swap
if ! swapon --show | grep -q "$NEW_SWAP"; then
    echo "Enabling new swap..."
    sudo swapon $NEW_SWAP
fi

# 3. Disable old swap
if [ -f "$OLD_SWAP" ]; then
    echo "Disabling old swap on SD card..."
    sudo swapoff $OLD_SWAP || echo "Old swap not active or already off."
    
    # Remove from fstab
    echo "Removing old swap from /etc/fstab..."
    sudo sed -i "\|$OLD_SWAP|d" /etc/fstab
    
    # Delete file
    echo "Deleting old swap file..."
    sudo rm -f $OLD_SWAP
fi

# 4. Persist new swap in fstab
if ! grep -q "$NEW_SWAP" /etc/fstab; then
    echo "Adding new swap to /etc/fstab..."
    echo "$NEW_SWAP none swap sw 0 0" | sudo tee -a /etc/fstab
fi

echo "=== Swap Migration Complete ==="
swapon --show
free -h
