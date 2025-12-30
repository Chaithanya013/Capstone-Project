#!/bin/bash

ENV=$1

if [ -z "$ENV" ]; then
  echo "Usage: ./deploy.sh <dev|staging|prod>"
  exit 1
fi

COMPOSE_FILE="docker-compose.$ENV.yml"

echo "Deploying environment: $ENV"
echo "Using compose file: $COMPOSE_FILE"

# Pull latest images (if using registry later)
docker compose -f $COMPOSE_FILE pull

# Stop existing containers
docker compose -f $COMPOSE_FILE down --remove-orphans

# Start new containers
docker compose -f $COMPOSE_FILE up -d --build

echo "Deployment completed for $ENV"
