#!/bin/bash
set -e

echo "Installing Docker..."
# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Add user to docker group
sudo usermod -aG docker jetson

# Install Docker Compose dependencies
sudo apt-get install -y libffi-dev python3-pip
sudo pip3 install docker-compose

echo "Docker installed."
docker --version
docker-compose --version
