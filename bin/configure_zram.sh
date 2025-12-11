#!/bin/bash
set -e

echo "=== Configuring ZRAM & Disabling Disk Swap ==="

# 1. Disable Disk Swap
if [ -f "/swapfile" ]; then
    echo "Disabling /swapfile on SD card..."
    sudo swapoff /swapfile || echo "Swap already off"
    
    echo "Removing from /etc/fstab..."
    sudo sed -i '\|/swapfile|d' /etc/fstab
    
    echo "Deleting /swapfile..."
    sudo rm -f /swapfile
    echo "Disk Swap Disabled."
else
    echo "No /swapfile found. Good."
fi

# 2. Configure ZRAM
# Check if zram is already active
if swapon --show | grep -q "zram"; then
    echo "ZRAM is already active."
    zramctl
else
    echo "Installing zram-tools..."
    sudo apt-get update
    sudo apt-get install -y zram-tools

    # Configure for 100% of RAM (2GB) with lz4 (fast) or zstd (better compression)
    # Jetson Nano CPU is weak, lz4 is safer for latency, but zstd gives more space.
    # Let's stick to defaults or set 50-100%.
    echo "ALGO=lz4" | sudo tee -a /etc/default/zramswap
    echo "PERCENT=100" | sudo tee -a /etc/default/zramswap

    echo "Restarting zramswap..."
    sudo systemctl restart zramswap
fi

echo "=== Memory Status ==="
free -h
swapon --show
zramctl
