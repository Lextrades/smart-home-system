#!/bin/bash
set -e

echo "Starting hardening process..."

# 1. Install UFW and Fail2Ban
echo "Installing UFW and Fail2Ban..."
sudo apt-get update
sudo apt-get install -y ufw fail2ban

# 2. Configure UFW
echo "Configuring UFW..."
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow ssh
# Allow standard web ports for future use (Cloudflare/Web Admin)
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp

# Enable UFW
# We use --force to avoid the "Command may disrupt existing ssh connections" prompt
echo "Enabling UFW..."
echo "y" | sudo ufw enable

# 3. Configure Fail2Ban
echo "Configuring Fail2Ban..."
# Create a local jail configuration to override defaults
sudo tee /etc/fail2ban/jail.local > /dev/null <<EOF
[DEFAULT]
bantime = 1h
findtime = 10m
maxretry = 5

[sshd]
enabled = true
port = ssh
logpath = %(sshd_log)s
backend = %(sshd_backend)s
EOF

# Restart Fail2Ban
echo "Restarting Fail2Ban..."
sudo systemctl restart fail2ban
sudo systemctl enable fail2ban

echo "Hardening complete. UFW and Fail2Ban are active."
sudo ufw status verbose
sudo fail2ban-client status sshd
