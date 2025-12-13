#!/bin/bash
echo "--- START LOCAL DIAG ---"
ssh -o ConnectTimeout=10 jetson@192.168.0.176 "echo 'REMOTE_ECHO'; df -h; echo '---'; ls -ld ~/smart-home-system/backups/snapshot_buffer"
echo "--- END LOCAL DIAG ---"
