# Project Restoration & Verification

## Deployment Workflow (Mac -> Jetson)
- [x] Restore `deploy.sh` script <!-- id: 0 -->
- [x] Restore `.vscode/tasks.json` for VS Code integration <!-- id: 1 -->
- [x] Verify Deployment (Run script and check files on Jetson) <!-- id: 2 -->

## Jetson Service Verification
- [x] Verify/Update Backup Logic (Optimize: Direct HDD-to-HDD sync) <!-- id: 18 -->
- [x] Verify Telegram Notifications (Logic in `backup_manager.sh` for HDD fail) <!-- id: 4 -->
- [x] Check Cloudflared Tunnel Status (`active`) <!-- id: 5 -->
- [x] Cleanup Legacy Git Repo on Jetson (Frees SD space) <!-- id: 19 -->

## Infrastructure Evolution
- [x] Plan Tailscale Migration (Secure, private, works with DS-Lite) <!-- id: 6 -->
    - [x] Disable Cloudflared Tunnel (Close public access) <!-- id: 7 -->
    - [x] Uninstall manual WireGuard (Services stopped) <!-- id: 8 -->
    - [x] Install Tailscale on Jetson <!-- id: 9 -->
    - [x] Authenticate & Connect (Active: jetlex-0) <!-- id: 10 -->
    - [x] Verify Access via Tailscale IP (<TAILSCALE_IP>) <!-- id: 11 -->

## Service Refinement
- [x] Configure Cloudflare Tunnel (Restore Public Sites, Exclude Files) <!-- id: 13 -->
    - [x] Edit `config.yml` to remove `files` ingress <!-- id: 14 -->
    - [x] Restart `cloudflared` service <!-- id: 15 -->
- [x] Debug `real-x-dreams.com` 404 Error (Backend OK, DNS fix proposed) <!-- id: 16 -->
- [x] Configure Nginx Proxy for `files` (Port 80 active) <!-- id: 17 -->

## 📑 Documentation Standard (Project Policy)
To ensure long-term maintainability and separation of concerns, the following structure is mandatory:

### 1. Living Documentation (Updates allowed)
*   **`#0_project_status.md`**: High-level checklist and current project state.
*   **`docs/#5_system/`**: Living playground for expansion stages.
    *   `0_system_infrastructure_plan.md`: Baseline infrastructure status.
    *   `n-system_playground_plan.md`: Current or planned stage (e.g., `1_system_voice-bridge_plan.md`).

### 2. Historical Foundation (Unchanged)
These files map the project's roots and should remain as static records:
*   **`#1_SETUP_GUIDE.md`**: Strategic workflow (Mac -> Jetson).
*   **`#1.1_SETUP_LOG.md`**: Technical history of the initial builds.

### 3. Private System Details (Local-Only)
Located in `private/system_architecture.md`. **MUST NEVER BE COMMITTED TO GIT.**
Contains specific hardware details, IPs, and sensitive service status.
