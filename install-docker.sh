#!/bin/bash

# Update package list and install dependencies
sudo apt update -y
if [ $? -ne 0 ]; then
  echo "Error: apt update failed"
  exit 1
fi

sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
if [ $? -ne 0 ]; then
  echo "Error: apt install dependencies failed"
  exit 1
fi

# Add Docker’s official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
if [ $? -ne 0 ]; then
  echo "Error: Adding Docker GPG key failed"
  exit 1
fi

# Set up the stable Docker repository
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
if [ $? -ne 0 ]; then
  echo "Error: Setting up Docker repository failed"
  exit 1
fi

# Update package list again
sudo apt update -y
if [ $? -ne 0 ]; then
  echo "Error: apt update failed (2nd time)"
  exit 1
fi

# Install Docker CE (Community Edition)
sudo apt install -y docker-ce
if [ $? -ne 0 ]; then
  echo "Error: Docker installation failed"
  exit 1
fi

# Enable and start Docker service
sudo systemctl enable docker
if [ $? -ne 0 ]; then
  echo "Error: Enabling Docker service failed"
  exit 1
fi

sudo systemctl start docker
if [ $? -ne 0 ]; then
  echo "Error: Starting Docker service failed"
  exit 1
fi

# Add user to docker group (Optional)
sudo usermod -aG docker $USER
if [ $? -ne 0 ]; then
    echo "Error: Adding user to docker group failed"
    exit 1
fi

echo "Docker installed successfully"
exit 0
