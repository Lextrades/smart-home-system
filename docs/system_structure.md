# Jetson Smart Home System

**Status**: Operational | **Device**: Jetson Nano (2GB) | **OS**: Ubuntu 20.04 (Qengineering)

## 📂 Project Structure

This repository contains the configuration and source code for the Jetson Smart Home Server.
The structure on the Jetson (`~/smart-home-system`) mirrors this repository but includes runtime directories.

### Directory Tree (Jetson)

```
~/smart-home-system/
├── web/                  # [PYTHON] Flask Web Application & Frontend
│   ├── app.py            # Main Application Entry Point
│   ├── .env              # Secrets (NOT in Git!) - see .env.example
│   ├── templates/        # HTML Templates
│   └── requirements.txt  # Python Dependencies
├── bin/                  # [BASH] Maintenance & Utility Scripts
├── config/               # [CONF] System Configurations (Nginx etc.)
├── git/                  # [GIT]  Local Bare Repository (Version Control)
├── installers/           # [MISC] Binary Installers & Setup Files
├── logs/                 # [LOGS] System & Cron Logs
└── backups/              # [DATA] Local Backup Buffer (Snapshots)
```

## 🚀 Deployment

The system is designed for **"Local Development"** directly on the Jetson via VS Code Remote-SSH.

### Remote Access
- **SSH**: `ssh jetson@<IP>`
- **VS Code**: Remote-SSH Extension -> Connect to Host.
- **Root Directory**: Open `/home/jetson/smart-home-system/` in VS Code.

## 🛠️ Key Components

| Component | Function | Status |
| :--- | :--- | :--- |
| **Web Platform** | Dashboard / Landing Page | Active (`web-platform.service`) |
| **Bless Node** | DePIN Mining Node | Active (`b7s.service`) |
| **Nginx** | Reverse Proxy (Port 80 -> 5000) | Active |
| **Backup Manager** | Daily Snapshots -> HDD | Active (Cron: 04:30) |

## ⚠️ Vital Commands

```bash
# Start/Restart Web App
sudo systemctl restart web-platform.service

# Check Web Logs
sudo journalctl -u web-platform.service -f

# Manual Backup Run
sudo ~/smart-home-system/bin/backup_manager.sh

# Mount Ext. HDD (if not auto-mounted)
sudo mount /mnt/hdd
# Unmount Ext. HDD (if not auto-mounted)
sudo umount /mnt/hdd
```
