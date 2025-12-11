# Backup Infrastructure Upgrade

I have implemented a new robust backup script `backup_manager.sh` that addresses your requirements for reliability and safe storage buffering.

## Key Features

### 1. Robust Backup Logic
- **Local Buffering**: Backups are now first created in `/home/jetson/smart-home-system/backups/snapshot_buffer`. This ensures that even if the HDD is offline, the backup *process* still succeeds.
- **Auto-Move**: If the HDD is mounted at `/mnt/hdd`, the script automatically moves the backup and logs to the final destination.
- **Fail-Safe**: If the HDD is NOT mounted, the backup stays in the local buffer, and a notification is triggered.

### 2. Updated Paths
Target locations have been aligned with your request:
- **Backups**: `/mnt/hdd/..`
- **Logs**: `/mnt/hdd/..`

### 3. Notification System (Telegram)
- **Integration**: The script now includes integration with Telegram.
- **Config**: You must edit `backup_manager.sh` and replace `YOUR_BOT_TOKEN_HERE` with your actual Telegram Bot Token.
- **Target**: Messages are sent to `@Telegram-Name`.
- **Triggers**: You will receive a notification if:
    - The local backup creation fails.
    - The HDD is not mounted (backup saved locally).
    - The move to HDD fails.

### 4. Git & Backup Setup (Stable SD Strategy)
We optimized the infrastructure to account for Jetson/HDD power constraints.

- **Git on SD Card**: `setup_git_remote.sh` initializes a bare repo at `/home/jetson/git/jetson-osx.git`.
    - **Why**: Stability. SD Card ensures 100% uptime for Git operations.
- **HDD Backups**: `backup_manager.sh` now backs up **TWO** locations to the HDD using Hardlinks:
    1.  The Project (`/home/jetson/smart-home-system`)
    2.  The Git Repo (`/home/jetson/smart-home-system/git/smart-home-system.git`)
    - **Result**: You have the speed of SD and the safety of HDD backups.

## Usage

### 1. Transfer & Init
Transfer the folder to `/home/jetson/smart-home-system`.
Run:
```bash
./setup_git_remote.sh
```
*Creates the local git hub.*

### 2. Activate Backup Schedule
Use the local path for the cronjob:
### 2. Activate Backup Schedule
Use the local path for the cronjob:

```bash
30 4 * * * /home/jetson/smart-home-system/bin/backup_manager.sh >> /home/jetson/>
```

### One-Time Setup:
1. open the script: `nano backup_manager.sh`
2. Update `TELEGRAM_BOT_TOKEN`.
3. Save and Exit.
4. Run it manually once to perform the "System Config Backup" immediately:
   ```bash
   ./backup_manager.sh
   ```

### One-Time Setup:
1. open the script: `nano backup_manager.sh`
2. Update `TELEGRAM_BOT_TOKEN`.
3. Save and Exit.
4. Run it manually once to perform the "System Config Backup" immediately:
   ```bash
   ./backup_manager.sh
   ```

## Verification
I verified the failover logic using a mock environment:
1.  **Test: HDD Mounted**: Verified files are moved to `/mnt/hdd/...`.
2.  **Test: HDD Missing**: Verified files are retained in `backup_buffer` and script acts safely.

All tests passed successfully.
