# Project Restoration & Verification

## Deployment Workflow (Mac -> Jetson)
- [x] Restore `deploy.sh` script <!-- id: 0 -->
- [x] Restore `.vscode/tasks.json` for VS Code integration <!-- id: 1 -->
- [x] Verify Deployment (Run script and check files on Jetson) <!-- id: 2 -->

## Jetson Service Verification
- [x] Verify/Update Backup Logic (Optimize: Direct HDD-to-HDD sync) <!-- id: 18 -->
- [x] Verify Telegram Notifications (Logic in `backup_manager.sh` for HDD fail) <!-- id: 4 -->
- [x] Check Cloudflared Tunnel Status (`active`) <!-- id: 5 -->

## Infrastructure Evolution
- [x] Plan Tailscale Migration (Secure, private, works with DS-Lite) <!-- id: 6 -->
    - [x] Disable Cloudflared Tunnel (Close public access) <!-- id: 7 -->
    - [x] Uninstall manual WireGuard (Services stopped) <!-- id: 8 -->
    - [x] Install Tailscale on Jetson <!-- id: 9 -->
    - [x] Authenticate & Connect (Active: jetlex-0) <!-- id: 10 -->
    - [x] Verify Access via Tailscale IP (100.77.57.25) <!-- id: 11 -->

## Service Refinement
- [x] Configure Cloudflare Tunnel (Restore Public Sites, Exclude Files) <!-- id: 13 -->
    - [x] Edit `config.yml` to remove `files` ingress <!-- id: 14 -->
    - [x] Restart `cloudflared` service <!-- id: 15 -->
- [x] Debug `real-x-dreams.com` 404 Error (Backend OK, DNS fix proposed) <!-- id: 16 -->
- [x] Configure Nginx Proxy for `files` (Port 80 active) <!-- id: 17 -->
