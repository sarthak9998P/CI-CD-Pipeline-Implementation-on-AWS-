#!/bin/bash
# rollback.sh — Roll back to previous Docker image
# Usage: ./rollback.sh <EC2_HOST>
# Author: Sarthak Pathade

set -e
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; NC='\033[0m'

EC2_HOST=$1
SSH_KEY="~/.ssh/deploy_key.pem"
CONTAINER_NAME="app"

echo -e "${RED}[ROLLBACK] Rolling back on: $EC2_HOST${NC}"

ssh -i $SSH_KEY -o StrictHostKeyChecking=no ec2-user@$EC2_HOST << 'EOF'
  echo "Stopping failed container..."
  docker stop app 2>/dev/null || true
  docker rm   app 2>/dev/null || true

  echo "Starting previous (latest stable) image..."
  PREV_IMAGE=$(docker images --format "{{.Repository}}:{{.Tag}}" | grep -v latest | sed -n '2p')

  if [ -z "$PREV_IMAGE" ]; then
    echo "No previous image found for rollback!"
    exit 1
  fi

  docker run -d \
    --name app \
    -p 80:80 \
    --restart unless-stopped \
    $PREV_IMAGE

  echo "Rollback complete — running: $PREV_IMAGE"
EOF

echo -e "${GREEN}✅ Rollback complete!${NC}"
