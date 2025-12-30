#!/bin/bash

ENV=$1

if [ -z "$ENV" ]; then
  echo "Usage: ./rollback.sh <dev|staging|prod>"
  exit 1
fi

COMPOSE_FILE="docker-compose.$ENV.yml"

echo "Rolling back environment: $ENV"

docker compose -f $COMPOSE_FILE down --remove-orphans
docker compose -f $COMPOSE_FILE up -d

echo "Rollback completed for $ENV"
