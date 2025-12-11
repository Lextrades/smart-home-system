#!/bin/bash
set -e

echo "Installing Ollama..."
curl -fsSL https://ollama.com/install.sh | sh

echo "Configuring Ollama storage..."
# Create systemd override directory
sudo mkdir -p /etc/systemd/system/ollama.service.d

# Create override file
sudo tee /etc/systemd/system/ollama.service.d/override.conf > /dev/null <<EOF
[Service]
Environment="OLLAMA_MODELS=/mnt/hdd/ollama"
EOF

echo "Reloading systemd and restarting Ollama..."
sudo systemctl daemon-reload
sudo systemctl restart ollama

echo "Ollama installed and configured."
systemctl status ollama --no-pager
