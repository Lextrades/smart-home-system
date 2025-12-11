#!/bin/bash
set -e

echo "Configuring UFW..."

# Reset to default
sudo ufw --force reset
sudo ufw default deny incoming
sudo ufw default allow outgoing

# 1. Emergency Access (WAN)
# SSH (22) and HTTP (80) must be open to the world for real-x-dreams.com
sudo ufw allow 22/tcp comment 'SSH Emergency Access'
sudo ufw allow 80/tcp comment 'HTTP Emergency Access'

# 2. Local Network Services (LAN Only)
# Assuming LAN is 192.168.x.x (Class C private)
LAN_SUBNET="192.168.0.0/16"

sudo ufw allow from $LAN_SUBNET to any port 445 proto tcp comment 'Samba LAN'
sudo ufw allow from $LAN_SUBNET to any port 139 proto tcp comment 'Samba NetBIOS LAN'
sudo ufw allow from $LAN_SUBNET to any port 61208 proto tcp comment 'Glances LAN'
sudo ufw allow from $LAN_SUBNET to any port 9443 proto tcp comment 'Portainer LAN'
sudo ufw allow from $LAN_SUBNET to any port 5678 proto tcp comment 'n8n LAN'

# Enable
echo "y" | sudo ufw enable

echo "UFW Configured."
sudo ufw status verbose
