# 📘 Workflow Guide: Mac Development -> Jetson Server

Dein professioneller Workflow: **Local-First mit Private Cloud Sync**.

---

## 🚀 1. Die Arbeit beginnen

1.  Öffne **Antigravity** auf deinem Mac.
2.  Arbeitsordner: `/Users/t_lex/.gemini/antigravity/playground/velvet-gravity`.

Der Code hier ist dein **Meister-Code**. Die AI hilft dir hier beim Programmieren.

## 🛠️ 2. Entwickeln & Testen (Speed Loop)

Für schnelle Tests während du programmierst (ohne Git-Historie):

1.  Code ändern.
2.  Drücke **`Cmd + Shift + B`** (Deploy to Jetson).
    *   *Kopiert die Dateien sofort rüber.*
3.  Öffne Terminal (SSH) im VS Code:
    *   `python3 app.py` (oder was du testen willst).

## 💾 3. Versionierung & Multi-Device (Slow Loop)

Wenn du einen Stand speichern willst oder das Gerät wechselst:

*   **Speichern (auf dem Mac):**
    ```bash
    git add .
    git commit -m "Mein Update"
    git push origin main
    ```
    *   *Das schiebt den Code permanent in das Git-Repo auf deinem Jetson.*

*   **Abrufen (auf Laptop B):**
    *   `git clone ssh://jetson@192.168.0.176/~/smart-home-system` (einmalig).
    *   `git pull` (um Updates zu holen).

## 🌍 Deine Private Cloud

*   **Zentraler Server:** Jetson Nano (`~/smart-home-system`).
*   **Backup:** Dein nächtlicher Cronjob auf dem Jetson sichert dieses Verzeichnis automatisch auf die HDD.
*   **Sicherheit:** Daten verlassen dein Netzwerk nur, wenn du es willst (via VPN/Domain).

---

## ⚡ Notfall-Befehle

*   **Reset (wenn alles kaputt ist):**
    `./deploy.sh` (überschreibt den Jetson hart mit dem Mac-Stand).
