#!/bin/sh
set -e

echo "Running DB migrations..."

psql \
  -h "$DB_HOST" \
  -U "$DB_USER" \
  -d "$DB_NAME" \
  -f /app/migrations/001_create_users.sql

echo "DB migrations completed successfully."
