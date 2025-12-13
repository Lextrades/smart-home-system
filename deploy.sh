#!/bin/bash
rsync -avz --exclude 'node_modules' --exclude '__pycache__' --exclude 'backups' --exclude '.git' --exclude '.vscode' ./ jetson@192.168.0.176:~/smart-home-system/
ssh jetson@192.168.0.176 "mkdir -p /mnt/hdd/public/real-x-dreams.com && rsync -av ~/smart-home-system/web/content/ /mnt/hdd/public/real-x-dreams.com/"
echo "✅ Deployed to Jetson and synced to HDD"
