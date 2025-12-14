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

# 1. Sync Code (Exclude heavyweight/private folders)
echo "🚀 Syncing Code to Jetson..."
rsync -avz --delete --exclude 'node_modules' --exclude '__pycache__' --exclude 'backups' --exclude '.git' --exclude '.vscode' --exclude 'web/content' ./ "${JETSON_USER}@${IP}:${JETSON_ROOT}"

# 2. Sync Public Content (Directly to HDD)
echo "📂 Syncing Web Content to HDD..."
ssh "${JETSON_USER}@${IP}" "mkdir -p ${HDD_PUBLIC_ROOT}"
rsync -avz --delete web/content/ "${JETSON_USER}@${IP}:${HDD_PUBLIC_ROOT}/"

# 3. Secure Private Git Backup (Mirror Key to HDD)
echo "📦 Creating Private Git Bundle Backup..."
git bundle create velvet-gravity.bundle --all
ssh "${JETSON_USER}@${IP}" "mkdir -p /mnt/hdd/Backups/Jetson_2GB"
rsync -avz --progress velvet-gravity.bundle "${JETSON_USER}@${IP}:/mnt/hdd/Backups/Jetson_2GB/git_repo_latest.bundle"
rm velvet-gravity.bundle

echo "✅ Deployed to ${IP}, synced to HDD, and updated Private Repo Backup."
