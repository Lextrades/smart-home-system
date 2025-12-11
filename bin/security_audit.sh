#!/bin/bash

LOG_FILE="/var/log/auth.log"
echo "=== Jetson Security Audit Report: $(date) ==="
echo ""

echo "--- Successful SSH Logins (Last 24h) ---"
grep "Accepted" "$LOG_FILE" | tail -n 10
echo ""

echo "--- Sudo Usage (Last 24h) ---"
grep "COMMAND=" "$LOG_FILE" | tail -n 10
echo ""

echo "--- Fail2Ban Bans (Current) ---"
sudo fail2ban-client status sshd
echo ""

echo "--- Disk Usage ---"
df -h / /mnt/hdd
echo ""

echo "=== End Report ==="
