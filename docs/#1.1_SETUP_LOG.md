# Jetson Setup Log - Final Master Archive
**Status**: Completed | **Date**: 2025-12-10

This archive contains the setup scripts and documentation for the Jetson Smart Home Server.
The active system has been fully migrated to `~/smart-home-system` on the Jetson Nano.

**Contents:**
- `system_master_plan.md`: The complete technical architecture documentation.
- `scripts_archive/`: The shell scripts used for migration and maintenance.
- `Jetson_Platform_Docs/`: Original setup guides.

---
## Project History (Legacy Log) System Setup & Migration Log (Nov 2025)

## 🎯 Ziel
Migration des Systems auf eine 128GB SD-Karte (Qengineering Image) bei gleichzeitiger Nutzung einer 2.7TB externen Festplatte (exFAT) für Daten und Backups.

## 🛠️ Durchgeführte Schritte & Lösungen

### 1. Vorbereitung & Backup
*   **Backup:** Mining-Daten (`bless_node`) und System-Configs (`smb.conf`, `ufw`, `ssh`) wurden auf die externe HDD gesichert.
*   **Hürde:** Verwirrung um Mount-Points (`/mnt/data` vs `/mnt/hdd`).
*   **Lösung:** Standardisierung auf `/mnt/hdd` für die externe Platte.

### 2. Neues System (Qengineering Ubuntu 20.04)
*   **SSH:** Zugriff wiederhergestellt (alter Host-Key auf Mac entfernt, Keys zurückkopiert).
*   **ExFAT:** Das neue System erkannte das Dateisystem nicht.
    *   *Fix:* `sudo apt install exfat-fuse exfat-utils`.
*   **ext4:**  ext4 ab >2020 erfordert Deaktivierung von `Feature C12`
    *   *Fix:* Neuer installer `e2fsprogs-1.47.0` und löschen von `Feature C12` für Kompatibilität auf Jetson.
*   **Mounting:** Automatisches Mounten (`defaults` in fstab) blockierte den Boot-Vorgang.
    *   *Fix:* Nutzung von `noauto` in `/etc/fstab`. Platte muss/kann bei Bedarf manuell gemountet werden, blockiert aber nicht den Start.

### 3. Mining (Bless Network)
*   **Setup:** Node läuft unabhängig auf der internen SD-Karte (für Stabilität).
*   **Hürde:** Die `bls-runtime` fehlte im Backup und war online schwer zu finden.
*   **Lösung:** Neuinstallation via offiziellem Skript (`curl ... | bash`), um Binary wiederherzustellen.
*   **Service:** `b7s.service` eingerichtet für Autostart.

### 4. Services & Apps
*   **Samba:** User `jetson` (System-User ohne Login) erstellt, damit Zugriff vom Mac funktioniert.
*   **Ollama:** Installiert. Modelle auf HDD ausgelagert (`OLLAMA_MODELS=/mnt/hdd/ollama/models`), um SD-Karte zu schonen.
*   **Docker & Portainer:** Installiert. Daten bleiben auf SD-Karte (`/var/lib/docker`) für Systemstabilität.
*   **Monitoring (Glances):** Web-Dashboard auf Port 61208.
    *   *Hürde:* Startete nicht im Web-Modus.
    *   *Lösung:* Fehlende Python-Abhängigkeiten (`fastapi`, `uvicorn`, `jinja2`) nachinstalliert und Bind-Address auf `0.0.0.0` gesetzt.

### 5. Sicherheit
*   **UFW:** Firewall aktiv (SSH, Samba, Glances erlaubt). IPv6 deaktiviert.
*   **Fail2Ban:** Schützt SSH vor Brute-Force.
*   **Auto-Updates:** `unattended-upgrades` aktiviert.

## 📂 Wichtige Pfade
*   **HDD Mount:** `/mnt/hdd` (Manuell: `sudo mount /mnt/hdd`)
*   **Backups:** `/mnt/hdd/Backups/Jetson_2GB`
*   **Ollama Models:** `/mnt/hdd/ollama/models`
*   **Mining Workspace:** `/home/jetson/b7s_workspace`

---
*Erstellt am 25.11.2025*
---
## Problems solved:

# Cronjobs:
```
crontab -e
```
-> Adjust line: 
```
30 4 * * * /home/jetson/jetson-osx/backup_manager.sh >> /home/jetson/backup.log >
```
The first two numbers determine the time:

1st number: The minute (0-59)
2nd number: The hour (0-23)

Examples:
30 4 * * * = Every day at 4:30 a.m.

!Attention! Deleting the cron job:
```
crontab -r
```
---
# HDD - Jetson Kompatibilität:
*ext4 - Neuformatierung für Sym-/Hardlinks / Private On-Device RAG Knowledge Vault erforderlich*

Repair file system (fsck)
```
sudo fsck -y /dev/sda4
```
**Problem - orphan_file / FEATURE_C12:**
(Compiling the newer e2fsprogs version and disabling the incompatible orphan_file / FEATURE_C12) is the technically perfect solution.

The e2fsprogs-1.47.0 folder (~/e2fsprogs-1.47.0/build) is your “workshop.” The repair to the hard drive itself is complete and permanent. 

! KEEP THE FOLDER !

Why you should keep it (the “emergency kit”)
You have determined that the standard tools on your Jetson are too old for your modern formatted hard drive. We have built the new tools (fsck, tune2fs) only in this folder, but have not installed them system-wide (so as not to damage your system).

Scenario: At some point, you pull the plug without shutting down, or there is a power failure.

Consequence: The hard drive is marked as “dirty” and needs to be checked (fsck).

Problem: The standard Linux on the Jetson will say, “I don't know it, I can't repair it.”

Solution: If you still have the folder, you can simply run ./e2fsck/e2fsck again and you're saved. If you delete it, you'll have to start all over again (download, compile...).
