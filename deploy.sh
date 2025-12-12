#!/bin/bash
rsync -avz --exclude 'node_modules' --exclude '__pycache__' --exclude 'backups' --exclude '.git' --exclude '.vscode' ./ jetson@<IP>:~/smart-home-system/
echo "✅ Deployed to Jetson"
