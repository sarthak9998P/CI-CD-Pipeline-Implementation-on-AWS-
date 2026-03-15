#!/bin/bash
# health_check.sh — Verify app is running after deployment
# Usage: ./health_check.sh <EC2_HOST>
# Author: Sarthak Pathade

set -e
GREEN='\033[0;32m'; RED='\033[0;31m'; YELLOW='\033[1;33m'; NC='\033[0m'

EC2_HOST=$1
MAX_RETRIES=5
SLEEP_SEC=10

echo -e "${YELLOW}[HEALTH CHECK] Checking: http://$EC2_HOST${NC}"

for i in $(seq 1 $MAX_RETRIES); do
  echo -e "${YELLOW}Attempt $i/$MAX_RETRIES...${NC}"

  HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" --max-time 10 http://$EC2_HOST || echo "000")

  if [ "$HTTP_CODE" == "200" ]; then
    echo -e "${GREEN}✅ Health Check PASSED — HTTP $HTTP_CODE${NC}"
    exit 0
  else
    echo -e "${RED}❌ HTTP $HTTP_CODE — Retrying in ${SLEEP_SEC}s...${NC}"
    sleep $SLEEP_SEC
  fi
done

echo -e "${RED}❌ Health Check FAILED after $MAX_RETRIES attempts!${NC}"
exit 1
