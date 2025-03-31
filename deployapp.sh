#!/bin/bash

# Clone the GitHub repo to the VM
git clone https://github.com/umesh218/test517.git /home/ubuntu/app

# Navigate to the project folder
cd /home/ubuntu/app

# Build the Docker image
sudo docker build -t mynodeapp .

# Run the container with updated port mapping (8080:8082)
sudo docker run -d -p 8080:8082 --name nodeapp mynodeapp
