# Jetson Infrastructure & Web Platform Walkthrough

I have successfully restored connectivity, optimized the system for AI workloads, verified security, and implemented the requested Premium Login System.

## Key Achievements

### 1. System Optimization (AI Ready)
- **Swap Upgrade**: Created a **6GB Swapfile** on the HDD, bringing total swap to **~7GB** (including ZRam). This prevents OOM errors when running Ollama models.
- **Boot Stability**: Verified `usb-storage.delay_use=10` preventing bootlocks.

### 2. Security Hardening
- **Firewall Fixed**: Removed an insecure UFW rule that allowed Samba traffic from "Anywhere". Access is now restricted to **LAN Only**.
- **Standard SSH**: Verified Key-based authentication is enforced.

### 3. Application Stack Verification
- **Infrastructure**: Docker Swarm, Portainer, and N8N are healthy.
- **Updates**: Installed **Watchtower** for automatic container updates (Daily at 4 AM).
- **AI/Mining**: Ollama and Bless-b7s verified running.

### 4. Web Platform (Phase VII)
I implemented a robust access control system for your Dev Environment.

#### Architecture
`Cloudflare Tunnel` -> `Nginx (Proxy)` -> `Flask App (Auth)` -> `Static Content`

#### Features
- **Premium Login UI**: Custom "Lex Systems" dark/glassmorphism design.
- **Secure Session**: Protects all content in `/mnt/hdd/public/lex.is-a.dev`.
- **Seamless Integration**: runs as a systemd service (`web-platform`).

## Verification Results
### Login System Test
```bash
> curl -I -L http://your.domain.com
HTTP/1.1 302 FOUND
Location: /login
...
HTTP/1.1 200 OK (Login Page Loaded)
```

## Maintenance Guide
- **Restart Web Platform**: `sudo systemctl restart web-platform`
- **View Logs**: `journalctl -u web-platform -f`
- **Update Content**: Simply edit files in `/mnt/hdd/public/lex.is-a.dev/`.
- **Change Credentials**: Edit `/home/jetson/web_platform/app.py` and restart the service (`sudo systemctl restart web-platform`).

## FAQ
### 1. Web vs SSH Access
- **dev.nextlevel.trading**: This is the **Visual Interface**. It allows you to *view* the website (`index.html`) stored on the HDD. The login here (lex/income) is just for viewing permission.
- **dev.nextlevel.trading**: This is the **Visual Interface**. It allows you to *view* the website (`index.html`) stored on the HDD. The login here (lex/income) is just for viewing permission.
- **ssh.nextlevel.trading**: This is for **Remote System Access** from outside your network.
    - **Note**: To use this, you CANNOT just type `ssh ...`.
    - **Requirement**: You must install `cloudflared` on your Mac and add this to your `~/.ssh/config`:
      ```
      Host ssh.your.domain.com
        ProxyCommand /usr/local/bin/cloudflared access ssh --hostname %h
      ```
    - **Reason for Timeout**: Without this config, your SSH tries to connect to Cloudflare's web server on port 22, which is blocked. The "Tunnel" needs the special helper to unwrap the traffic.

### 2. "No Effect" on Login?
- If the login page just reloads, it means the session wasn't saved.
- **Fix Applied**: I have stabilized the session handling (Fixed Secret Key). Please try again.
- **Wrong Password?**: You will now see a red "Invalid Credentials" message.

### 3. Security: Is Port 22 safe?
- **Yes, extremely safe.**
- Unlike a normal server, **Port 22 is NOT open on your router**. It is blocked to the outside world.
- The "Tunnel" acts like a secret underground cable. Only someone with `cloudflared` installed AND the correct hostname can even knock on the door.
- Bots scanning the internet for "Open Port 22" will **never find your Jetson**, because it exists behind Cloudflare's shield.

### 4. What is `cert.pem`?
- This is your **Cloudflare Admin Certificate**.
- It was created when you logged in to setup the tunnel.
- **Keep it safe!** It verifies that *you* own the tunnel configuration. It is not needed for daily browsing, but is needed if you want to create new tunnels or change routing.

## Future Roadmap: Multi-Domain Access
You asked about separating "Restricted content" vs "Full Access" via domains. A proposed architecture:

1.  **dev.nextlevel.trading** (Current)
    -   **Access**: Restricted (Read-Only).
    -   **Target**: `/mnt/hdd/public/lex.is-a.dev`.
    -   **Tech**: Flask App (Login required).

2.  **real-x-dreams.com** (Future Proposal)
    -   **Access**: Full Management (Read/Write Entire HDD).
    -   **Tech**: **FileBrowser** or **VS Code Server** running on Jetson.
    -   **Flow**: Login here gives you a Windows-Explorer-like interface to manage files, upload data, and check system stats.
    -   **Implementation**: We can set this up as a new Docker Container and route the new domain to it.
