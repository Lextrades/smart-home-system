# Nicehash Integration Guide (Hobby Mining)

## Goal Description
Prepare a private workspace for mining activities (Nicehash compatible) on the Jetson Nano without cluttering the main public repository. This uses XMRig inside Docker for maximum isolation and CPU-based mining.

## Strategic Decision: Hybrid Private Workspace
- **Folder**: `mining/nicehash` (Created)
- **Git State**: Ignored via `.gitignore`. This project remains "clean" publicly.
- **Backend**: Connecting to Nicehash Stratum servers using XMRig (ARM64 Docker support).

## Proposed Components

### 1. Private Directory Structure
```
~/smart-home-system/mining/nicehash/
├── docker-compose.yml   # Orchestration for the miner
└── config/
    └── config.json      # XMRig specific configuration (Wallet & Pool)
```

### 2. [NEW] docker-compose.yml (Template)
```yaml
version: '3'
services:
  miner:
    image: metal3d/xmrig:latest-arm64
    container_name: nicehash-miner
    restart: unless-stopped
    command: [
      "--url=stratum+tcp://randomxmonero.eu-west.nicehash.com:3380",
      "--user=YOUR_NICEHASH_WALLET_ADDRESS.JETSON_WORKER_NAME",
      "--pass=x",
      "--algo=rx/0"
    ]
    # Limit resources to prevent overheating / lagging your Smart Home apps
    deploy:
      resources:
        limits:
          cpus: '3.0' # Leave 1 core for the OS and Smart Home Web
```

## Setup Instructions

1.  **Get Wallet Address**: Login to Nicehash and get your mining address for "RandomXMonero".
2.  **Edit Config**: Update the `docker-compose.yml` with your address.
3.  **Run**:
    ```bash
    cd ~/smart-home-system/mining/nicehash
    docker compose up -d
    ```
4.  **Monitor**: 
    - `docker logs -f nicehash-miner`
    - Check Nicehash Dashboard online.

## Security & Performance Notes
- **Temperature**: Jetson Nano can get hot under 100% CPU load. Ensure good cooling.
- **Resource Limits**: The `cpus: '3.0'` limit in the compose file is critical so your web platform stays responsive.
- **Isolation**: Docker ensures that mining binaries cannot access your private Smart Home keys or files.
