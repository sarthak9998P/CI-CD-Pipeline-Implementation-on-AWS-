#!/bin/bash
# deploy.sh — SSH into EC2 and deploy new Docker container
# Usage: ./deploy.sh <EC2_HOST> <IMAGE_TAG>
# Author: Sarthak Pathade

set -e
GREEN='\033[0;32m'; YELLOW='\033[1;33m'; RED='\033[0;31m'; NC='\033[0m'

EC2_HOST=$1
IMAGE_TAG=$2
SSH_KEY="~/.ssh/deploy_key.pem"
APP_PORT=80
CONTAINER_NAME="app"

if [ -z "$EC2_HOST" ] || [ -z "$IMAGE_TAG" ]; then
  echo "Usage: ./deploy.sh <EC2_HOST> <IMAGE_TAG>"
  exit 1
fi

echo -e "${YELLOW}[DEPLOY] Deploying to EC2: $EC2_HOST${NC}"

ssh -i $SSH_KEY -o StrictHostKeyChecking=no ec2-user@$EC2_HOST << EOF
  set -e
  echo "Logging in to ECR..."
  aws ecr get-login-password --region ap-south-1 | \
    docker login --username AWS --password-stdin \
    \$(aws sts get-caller-identity --query Account --output text).dkr.ecr.ap-south-1.amazonaws.com

  echo "Pulling new image: $IMAGE_TAG"
  docker pull \$ECR_REPO:$IMAGE_TAG

  echo "Stopping old container (if running)..."
  docker stop $CONTAINER_NAME 2>/dev/null || true
  docker rm   $CONTAINER_NAME 2>/dev/null || true

  echo "Starting new container..."
  docker run -d \
    --name $CONTAINER_NAME \
    -p $APP_PORT:80 \
    --restart unless-stopped \
    \$ECR_REPO:$IMAGE_TAG

  echo "Deployment done on EC2!"
EOF

echo -e "${GREEN}✅ Deployment successful — Image: $IMAGE_TAG${NC}"
