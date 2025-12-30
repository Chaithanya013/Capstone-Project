#!/bin/bash

ENV=$1

if [ -z "$ENV" ]; then
  echo "Usage: ./health_check.sh <dev|staging|prod>"
  exit 1
fi

case $ENV in
  dev)
    PORT=5000
    ;;
  staging)
    PORT=5001
    ;;
  prod)
    PORT=5002
    ;;
  *)
    echo "Invalid environment"
    exit 1
    ;;
esac

echo "Checking
 health on port $PORT..."

STATUS=$(curl -s http://localhost:$PORT/health | grep -o "UP")

if [ "$STATUS" == "UP" ]; then
  echo "Health check PASSED for $ENV"
  exit 0
else
  echo "Health check FAILED for $ENV"
  exit 1
fi
