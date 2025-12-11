#!/bin/bash
set -e

echo "Configuring SSH CA..."

# Move CA pub key to /etc/ssh
sudo mv ~/jetson_ca.pub /etc/ssh/jetson_ca.pub
sudo chown root:root /etc/ssh/jetson_ca.pub
sudo chmod 644 /etc/ssh/jetson_ca.pub

# Update sshd_config
# Check if already configured
if grep -q "TrustedUserCAKeys" /etc/ssh/sshd_config; then
    echo "TrustedUserCAKeys already configured."
else
    echo "Adding TrustedUserCAKeys to sshd_config..."
    echo "TrustedUserCAKeys /etc/ssh/jetson_ca.pub" | sudo tee -a /etc/ssh/sshd_config
fi

# Restart SSH
echo "Restarting SSH..."
sudo systemctl restart ssh

echo "SSH CA configured."
