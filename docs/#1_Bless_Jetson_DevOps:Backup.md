#1_Bless - Jetson --- DevOps/Backup
Status: **OPERATIONAL**

## Node Identität
- **Node-ID:** `12D3KooWLft9VD3GK5B637XUs1fhq3ijELB3s5SeDjz4Re3myemU`
- **Host:** `head-run.bls.dev`
- **Dashboard:** https://bless.network/dashboard/nodes

---
## I. System-Dienst (Autostart)
Der Node läuft als systemd-Service namens **`b7s`**.

**Status prüfen:**
```bash
sudo systemctl status b7s
```

**Service-Steuerung:**
```bash
sudo systemctl stop b7s      # Stoppen
sudo systemctl start b7s     # Starten
sudo systemctl restart b7s   # Neustart (nötig nach Config-Änderung)
sudo systemctl disable b7s   # Autostart deaktivieren (Ressourcen sparen)
```

**Service-Definition (Für Neuaufbau):**
Pfad: `/etc/systemd/system/b7s.service`
```ini
[Unit]
Description=Bless Node Mining Service
After=network.target

[Service]
User=jetson
# Config liegt real in ~/smart-home-system/installers, wird aber via Symlink ~/b7s.yaml gefunden
ExecStart=/usr/local/bin/b7s --config /home/jetson/b7s.yaml
Restart=on-failure
RestartSec=10

[Install]
WantedBy=multi-user.target
```

---
## II. Wichtige Konfiguration (Symlink-Trick)
Da das System aufgeräumt wurde (`~/smart-home-system`), die Binrary aber fest codierte Pfade erwartet, nutzen wir einen **Symlink**.

**Bei Neuinstallation beachten:**
1. Config liegt in: `~/smart-home-system/installers/b7s.yaml`
2. Symlink erstellen:
   ```bash
   ln -s ~/smart-home-system/installers/b7s.yaml ~/b7s.yaml
   ```

---
## III. Backup Strategie
Der Node ist Teil des globalen **Jetson Smart Home Backups**.

**Automatisch:**
Täglich via `backup_manager.sh`. Sichert `~/smart-home-system` (inkl. Config & Runtime).

**Manuelles "Notfall-Paket" (Nur Key & Config):**
Falls man nur die Identität sichern will (z.B. auf USB-Stick):
```bash
tar -czf bless_identity.tar.gz ~/smart-home-system/installers/b7s.yaml ~/private.key
```
*(Hinweis: Der `private.key` ist das ALLERWICHTIGSTE. Ohne ihn ist die Node-ID und Reputation verloren.)*