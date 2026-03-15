#!/bin/bash
# build.sh — Build and push Docker image to ECR
# Usage: ./build.sh <ECR_REPO_URI> <IMAGE_TAG>
# Author: Sarthak Pathade

set -e
GREEN='\033[0;32m'; YELLOW='\033[1;33m'; NC='\033[0m'

ECR_REPO=$1
IMAGE_TAG=$2

if [ -z "$ECR_REPO" ] || [ -z "$IMAGE_TAG" ]; then
  echo "Usage: ./build.sh <ECR_REPO_URI> <IMAGE_TAG>"
  exit 1
fi

echo -e "${YELLOW}[BUILD] Building Docker image...${NC}"
docker build -t $ECR_REPO:$IMAGE_TAG -t $ECR_REPO:latest .

echo -e "${YELLOW}[PUSH] Pushing to ECR...${NC}"
docker push $ECR_REPO:$IMAGE_TAG
docker push $ECR_REPO:latest

echo -e "${GREEN}✅ Image built and pushed: $ECR_REPO:$IMAGE_TAG${NC}"
