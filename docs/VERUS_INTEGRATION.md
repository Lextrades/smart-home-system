# Verus Integration Guide (ARM64 Optimized)

## Goal Description
Prepare a private workspace for mining Verus Coin (VRSC) on the Jetson Nano. Verus uses the VerusHash algorithm, which is specifically optimized for CPU mining on ARM64 architectures (like the Jetson Nano).

## Strategic Decision: Hybrid Private Workspace
- **Folder**: `mining/verus` (Created)
- **Git State**: Ignored via `.gitignore`. Private from the public repo.
- **Backend**: Connecting to Verus pools using optimized CCminer or Hellminer (ARM64 Docker support).

## Proposed Components

### 1. Private Directory Structure
```
~/smart-home-system/mining/verus/
├── docker-compose.yml   # Orchestration for the Verus miner
└── config/
    └── miner.conf       # Optional config for advance settings
```

### 2. [NEW] docker-compose.yml (Template)
Located in `mining/verus/docker-compose.yml`:
```yaml
version: '3'
services:
  verus-miner:
    image: moniton/hellminer:latest-arm64
    container_name: verus-miner
    restart: unless-stopped
    command: [
      "-c", "stratum+tcp://na.luckpool.net:3956",
      "-u", "YOUR_VERUS_WALLET_ADDRESS.JETSON_WORKER",
      "-p", "x",
      "--cpu", "3" 
    ]
    # Resource management to protect the Jetson's 2GB RAM and Smart Home responsiveness
    deploy:
      resources:
        limits:
          cpus: '3.0' 
```

## Setup Instructions

1.  **Get Wallet**: Use the Verus mobile or desktop wallet to generate an address.
2.  **Pool**: This template uses LuckPool (a popular Verus pool).
3.  **Run**:
    ```bash
    cd ~/smart-home-system/mining/verus
    docker compose up -d
    ```
4.  **Monitor**: 
    - `docker logs -f verus-miner`
    - View your progress on luckpool.net (enter your wallet address).

## Security & Performance Notes
- **Effortless Mining**: VerusHash is "friendly" to your Jetson and doesn't stress the GPU, but it will use CPU heat.
- **Persistence**: Your settings in the `mining/` folder are backed up to the HDD by our system scripts, but never uploaded to GitHub.
