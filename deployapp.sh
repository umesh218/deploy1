#!/bin/bash

# Clone the GitHub repo to the VM
git clone https://github.com/umesh218/test517.git /home/ubuntu/app
if [ $? -ne 0 ]; then
  echo "Error: Git clone failed"
  exit 1
fi

# Navigate to the project folder
cd /home/ubuntu/app
if [ $? -ne 0 ]; then
  echo "Error: Change directory failed"
  exit 1
fi

# Build the Docker image
sudo docker build -t mynodeapp .
if [ $? -ne 0 ]; then
  echo "Error: Docker build failed"
  exit 1
fi

# Run the container with updated port mapping (8080:8082), environment variables, and restart policy
sudo docker run -d \
  -p 8080:8082 \
  --name nodeapp \
  --restart always \
  -e "NODE_ENV=production" \ # Example environment variable
  mynodeapp
if [ $? -ne 0 ]; then
  echo "Error: Docker run failed"
  exit 1
fi

echo "Application deployed successfully"
exit 0
