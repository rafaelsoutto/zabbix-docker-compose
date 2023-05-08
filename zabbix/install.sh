#!/bin/bash

# Update package lists and upgrade installed packages
sudo apt update
sudo apt upgrade

# Install required packages for Docker
echo "Install needed packages"
sudo apt-get install ca-certificates curl gnupg lsb-release -y

# Add Docker's GPG key to the keyring
echo "Add Docker’s official GPG key"
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Add Docker's repository to apt sources list
echo "Add Docker repository to apt sources list"
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update package lists again to include Docker repository
sudo apt-get update

# Install Docker and containerd
sudo apt-get install docker-ce docker-ce-cli containerd.io -y

# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/download/v2.2.3/docker-compose-linux-x86_64" -o /usr/local/bin/docker-compose

# Make Docker Compose executable
sudo chmod +x /usr/local/bin/docker-compose