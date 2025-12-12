# 🧠 Smart Home System & Antigravity AI Workflow

> **Universal Development Kit** for Jetson Nano, Raspberry Pi, and Linux Servers.
> *Managed & Generated with Google Antigravity AI.*

## 🌟 Über dieses Projekt

Dieses Repository ist mehr als nur Smart-Home-Code. Es ist eine **Blaupause für AI-gestützte Entwicklung** auf Embedded Hardware.
Ursprünglich für den **NVIDIA Jetson Nano** entwickelt, lässt sich dieser Workflow auf jede Linux-Hardware (Raspberry Pi 4/5, Intel NUC, VPS) übertragen.

## 🤖 Der "Antigravity" Workflow

Da moderne AI-Modelle oft zu schwer für kleine Edge-Geräte sind, nutzen wir einen **Hybrid-Ansatz**:

1.  **Thinking (Mac/PC):** Die AI (Antigravity Agent) lebt auf deinem leistungsstarken Entwickler-Rechner.
2.  **Acting (Edge):** Der Code wird *für* das Zielgerät geschrieben und dort ausgeführt.

### Wie du dieses Projekt für DEINE Hardware anpasst

Du hast keinen Jetson? Kein Problem. Nutze Antigravity, um das Projekt umzubauen:

1.  **Lade das Projekt:** Clone dieses Repo auf deinen Mac/PC.
2.  **Starte Antigravity:** Öffne den Ordner im Agent-Editor.
3.  **Prompt an die AI:**
    > "Ich möchte dieses Projekt auf einem [Raspberry Pi 5] mit [Ubuntu 24.04] deployen. Bitte analysiere `docs` und `deploy.sh` und `tasks.json` und pass sie an. Ersetze Jetson-spezifische Docker-Container durch generische ARM64-Versionen."

Die AI wird für dich:
*   Scripts umschreiben (`rsync` Ziel-IPs ändern).
*   `docker-compose.yml` anpassen (z.B. NVIDIA Runtime entfernen).
*   Systemd-Services für deine Distro optimieren.

## 🛠 Einrichtung (Universal)

### 1. Vorraussetzungen
*   **Host:** Mac oder PC mit VS Code & Antigravity Extension.
*   **Target:** Linux-Gerät (SSH aktiviert).
*   **Netzwerk:** Beide Geräte im selben WLAN/LAN.

### 2. Schnelleinrichtung
1.  **SSH Config:** Stelle sicher, dass du dich per SSH verbinden kannst (`ssh user@ip`).
2.  **Repo Clonen:** `git clone <URL>`.
4.  **docs-scripte #0-#4:** Tausche `your.domain.com` & `Telegram-Name` gegen eigenen Daten & `/mnt/hdd/..` gegen persönlichen Backup-Ordner!
5.  **Deploy Script:** Bearbeite `deploy.sh` und trage deine Target-IP ein.
    ```bash
    # deploy.sh
    rsync ... ./ user@<IP>:~/dein-projekt/
    ```
6.  **Loslegen:** Drücke `Cmd+Shift+B` (Deploy) in VS Code.

## 🔒 Sicherheit
*   Credentials gehören in `.env` Dateien (werden nicht committed).
*   Der Master-Branch ist sauber gehalten für die Öffentlichkeit.
*   Private Anpassungen? Forke das Repo oder nutze es als Template für deine private Git-Instanz.

---
*Created with ❤️ and 🤖 using Google Antigravity.*
