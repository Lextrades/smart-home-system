# Jetson Smart Home System - Master Documentation
> **Status**: Operational | **Role**: Standalone Smart Home Server | **Date**: 2025-12-10

This document serves as the "Master File" for the technical infrastructure of the Jetson Nano. It summarizes the directory structure, security mechanisms, backup strategy, and installed services for disaster recovery or future development.

## 1. System Architecture

### Core Filesystem
 The system has been restructured (Dec 2025) to a clean, semantic layout in `~/smart-home-system`.
- **Root**: `/home/jetson/smart-home-system`
  - `bin/`: Executable maintenance scripts (Backup, Firewall, Updates).
  - `web/`: Python/Flask Application & Frontend (`app.py`, `templates/`).
  - `config/`: Custom configs (Nginx, generic).
  - `logs/`: Centralized log location (Backup logs, System logs).
  - `backups/`: **Local Snapshot Buffer** (Crucial for disaster recovery).
  - `git/`: Local Git Repository (`smart-home-system.git`).

### Hardware Optimizations
- **Swap**: Moved to external storage (if configured via `move_swap.sh`) to save SD card wear.
- **ZRAM**: Compression enabled (`configure_zram.sh`) to maximize the 2GB RAM.

## 2. Backup & Recovery Strategy

**Philosophy**: "Local Buffer First" - Ensures data safety even if external storage fails.
1.  **Automated Job**: Runs daily at **02:00** via Root Cron (`sudo crontab -e`).
2.  **Phase 1 (Buffer)**: Mirrors the *entire* `smart-home-system` + `/etc/nginx` + `/etc/letsencrypt` to `~/smart-home-system/backups/snapshot_buffer`.
3.  **Phase 2 (Archive)**: 
    - **If HDD Detected** (`/mnt/hdd`): Moves snapshot to Hard Drive with date stamping (`backup_YYYYMMDD...`).
    - **If HDD Missing**: Sends **Telegram Alert** ⚠️ to User, keeps backup locally safe on SD card.

**Recovery (Worst Case)**:
- **Files**: Copy `snapshot_buffer` content back to `~/smart-home-system`.
- **System**: Re-flash OS -> Run `backup_manager.sh` from HDD (or buffer) to restore data.

## 3. Network & Security

### Connectivity
- **IPv4**: Enabled (Static IP suggested: `192.168.0.176`).
- **IPv6**: Disabled (`disable_ipv6.sh`) to prevent leaks/complexity.
- **Remote Access**:
  - **SSH**: Hardened (Key-only auth, Password disabled, standard port).
  - **Cloudflare Tunnel**: Installed (`install_cloudflared.sh`) for secure external access without opening router ports.

### Security
- **Firewall (UFW)**: Configured via `apply_firewall.sh`. Deny Incoming / Allow Outgoing. Open Ports: SSH (22), Web (80/443), Custom App Ports (5000/8000).
- **User Role**: `jetson` user is owner of code; `root` executes system maintenance (cron/backups).

## 4. Installed Services

| Service | Status | Path / Command | Description |
| :--- | :--- | :--- | :--- |
| **Web Platform** | Dev | `~/smart-home-system/web/app.py` | Flask Login/Link Dashboard (Future UI). |
| **Docker** | Active | `install_docker.sh` | Container runtime for n8n/Ollama. |
| **Ollama** | Installed | `install_ollama.sh` | Local LLM inference. |
| **Nginx** | Active | `/etc/nginx` | Reverse Proxy for Web Platform. |
| **n8n** | Configured | `n8n-stack.yml` | Workflow Automation. |

## 5. Development Workflow

**Old Way**: Edit on Mac -> Push to Jetson.
**New Way (Standalone)**:
- **Edit**: VS Code / Nano directly on Jetson (via SSH / Remote-SSH).
- **Version Control**: Local Git in `~/smart-home-system/git`. Commits are stored locally; Backup Manager secures them to HDD daily.

## 6. Vital Commands Cheat-Sheet

```bash
# Manual Backup Run
sudo /home/jetson/smart-home-system/bin/backup_manager.sh

# Check Logs
tail -f ~/smart-home-system/logs/cron.log

# Edit Cronjob
sudo crontab -e
```
