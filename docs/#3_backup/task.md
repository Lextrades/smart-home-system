# Backup and Log Infrastructure Refinement

- [x] Research current backup and cronjob implementation <!-- id: 0 -->
- [x] Design new backup strategy with local buffering and HDD check <!-- id: 1 -->
- [x] Implement path changes for backups (`/mnt/hdd/..`) and logs (`/mnt/hdd/..`) <!-- id: 2 -->
- [x] Implement local buffering logic (store locally, move if HDD mounted) <!-- id: 3 -->
- [x] Implement notification system for HDD unavailability <!-- id: 4 -->
- [x] Verify changes and test fallback scenarios <!-- id: 5 -->
- [x] Implement Telegram notification logic in `backup_manager.sh` (@Telegram-Name) <!-- id: 6 -->
- [x] Replace/Update cronjob to use `backup_manager.sh` <!-- id: 8 -->
- [x] Add additional config files (`authorized_keys`, `smb.conf`, etc.) to `backup_manager.sh` <!-- id: 9 -->
- [-] Create `migrate_to_hdd.sh` to move project files to `/mnt/hdd` and setup Git (Cancelled: Power Issues) <!-- id: 10 -->
- [x] Update `backup_manager.sh` to use Hardlinks (`cp -al` or `rsync`) for HDD-to-HDD backups <!-- id: 11 -->
- [x] Revert `backup_manager.sh` source paths to Local (SD Card) location <!-- id: 12 -->
- [x] Update `setup_git_remote.sh` to initialize Git on SD Card (`/home/jetson/git/`) instead of HDD <!-- id: 14 -->
- [x] Update `backup_manager.sh` to include `/home/jetson/git` in the backup set <!-- id: 15 -->
- [x] Verify local Git setup and comprehensive backup <!-- id: 13 -->
