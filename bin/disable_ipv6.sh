#!/bin/bash
set -e

echo "Disabling IPv6..."
# Create sysctl config
echo "net.ipv6.conf.all.disable_ipv6 = 1" | sudo tee /etc/sysctl.d/99-disable-ipv6.conf
echo "net.ipv6.conf.default.disable_ipv6 = 1" | sudo tee -a /etc/sysctl.d/99-disable-ipv6.conf
echo "net.ipv6.conf.lo.disable_ipv6 = 1" | sudo tee -a /etc/sysctl.d/99-disable-ipv6.conf

# Apply changes
sudo sysctl -p /etc/sysctl.d/99-disable-ipv6.conf

echo "IPv6 disabled."
cat /proc/sys/net/ipv6/conf/all/disable_ipv6
