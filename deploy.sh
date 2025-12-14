#!/bin/bash

# Safety Check: Ensure Clean Git State
if [[ -n $(git status --porcelain) ]]; then
    echo "❌ ERROR: Uncommitted changes detected!"
    echo "Please commit your changes before deploying to ensure you have a restore point."
    echo "Run: 'git commit -am \"Description\"' then try again."
    exit 1
fi

# Load Configuration
if [ -f ".deploy_config" ]; then
    source ".deploy_config"
else
    echo "❌ ERROR: .deploy_config not found!"
    echo "Please create '.deploy_config' with JETSON_USER, IP, JETSON_ROOT, and HDD_PUBLIC_ROOT."
    exit 1
fi

rsync -avz --delete --exclude 'node_modules' --exclude '__pycache__' --exclude 'backups' --exclude '.git' --exclude '.vscode' --exclude 'web/content' ./ "${JETSON_USER}@${IP}:${JETSON_ROOT}"
ssh "${JETSON_USER}@${IP}" "mkdir -p /mnt/hdd/Backups/Jetson_2GB"
rsync -avz --progress velvet-gravity.bundle "${JETSON_USER}@${IP}:/mnt/hdd/Backups/Jetson_2GB/git_repo_latest.bundle"
echo "✅ Deployed to ${IP} and synced to HDD"
