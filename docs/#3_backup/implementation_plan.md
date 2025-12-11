# Final Infrastructure Optimization Plan (SD Git / HDD Backup)

We are finalizing the setup for maximum stability. The active Git Repository will live on the **SD Card** to prevent corruption from HDD power loss. The HDD will serve purely as a nightly backup destination.

## Proposed Changes

### [MODIFY] [setup_git_remote.sh](file:///Users/t_lex/Downloads/smart-home-system-main/setup_git_remote.sh)
- **Target Change**: Initialize bare repo at `/home/jetson/smart-home-system/git/smart-home-system.git` (SD Card) instead of `/mnt/hdd/...`.
- **Remote Name**: Name the remote `local_hub` or `sd` (or keep `origin`) to distinguish it easily.

### [MODIFY] [backup_manager.sh](file:///Users/t_lex/Downloads/smart-home-system-main/docs/#4_scripts_archive/backup_manager.sh)
- **Backup Additions**: We must now also backup the `/home/jetson/smart-home-system/git` directory to the HDD so the repo history is safe.
- **Logic**:
    1. Rsync the *Project Folder* (Working Directory) -> HDD (Snapshot).
    2. Rsync the *Git Repo Folder* (Bare Repo) -> HDD (Snapshot).

### [MODIFY] [README_DEPLOY.md](file:///Users/t_lex/Downloads/smart-home-system-main/README_DEPLOY.md)
- Update deployment instructions to reflect the SD Card Git path.

## Verification Plan
1. **Mock Git Backup**: Update `test_backup.sh` to verify that both the project folder AND the git folder are backed up to the HDD mock.
