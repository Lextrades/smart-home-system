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

# 1. Ensure HDD is mounted (since fstab is set to noauto for boot safety)
echo "🔗 Ensuring HDD is mounted..."
ssh "${JETSON_USER}@${IP}" "sudo mount /mnt/hdd 2>/dev/null || true; mountpoint -q /mnt/hdd || { echo '❌ ERROR: HDD not mounted! Check hardware.'; exit 1; }"

# 2. Sync Code (Exclude heavyweight/private folders)
echo "🚀 Syncing Code to Jetson..."
rsync -avz --delete --exclude 'node_modules' --exclude '__pycache__' --exclude 'backups' --exclude '.git' --exclude '.vscode' --exclude 'web/content' ./ "${JETSON_USER}@${IP}:${JETSON_ROOT}"

# 3. Sync Public Content (Directly to HDD)
echo "📂 Syncing Web Content to HDD..."
ssh "${JETSON_USER}@${IP}" "mkdir -p ${HDD_PUBLIC_ROOT}"
rsync -avz --delete web/content/ "${JETSON_USER}@${IP}:${HDD_PUBLIC_ROOT}/"

# 4. Secure Private Git Backup (Mirror Key to HDD)
echo "📦 Creating Private Git Bundle Backup..."
git bundle create velvet-gravity.bundle --all
ssh "${JETSON_USER}@${IP}" "mkdir -p /mnt/hdd/Backups/Jetson_2GB"
rsync -avz --progress velvet-gravity.bundle "${JETSON_USER}@${IP}:/mnt/hdd/Backups/Jetson_2GB/git_repo_latest.bundle"
rm velvet-gravity.bundle

# 5. Restart Docker Containers
echo "🐳 Building & Restarting Docker Containers..."
ssh "${JETSON_USER}@${IP}" "cd ${JETSON_ROOT} && docker compose up -d --build"

echo "✅ Deployed to ${IP}, synced to HDD, Updated Repo Backup, and Restarted Docker!"
