#!/bin/bash
set -e

echo "Installing cloudflared..."
# Download the latest arm64 release
wget -q https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-arm64 -O cloudflared
chmod +x cloudflared
sudo mv cloudflared /usr/local/bin/

echo "cloudflared installed."
cloudflared --version
