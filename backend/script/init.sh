#!/usr/bin/env bash
set -euo pipefail

# Resolve backend directory (parent of this script dir)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKEND_DIR="${SCRIPT_DIR%/script}"
cd "$BACKEND_DIR"

# Initialize Laravel project inside ./backend using Composer Docker image
if [ -f "artisan" ]; then
  echo "Laravel project already present (artisan found). Skipping create-project."
else
  docker run --rm -it -v "$PWD":/app -w /app composer:2 \
    composer create-project laravel/laravel .
fi

# Build app image (with PHP extensions + composer inside)
docker compose build app

# Install dependencies (ensure vendor is present)
docker compose run --rm app composer install

# Copy .env if missing and set DB defaults
if [ ! -f .env ] && [ -f .env.example ]; then
  cp .env.example .env
fi

# Ensure DB settings for Postgres in .env
if [ -f .env ]; then
  # GNU/BSD compatible sed in-place handling
  sed -i.bak -e 's#^APP_URL=.*#APP_URL=http://localhost:8080#' .env || true
  sed -i.bak -e 's#^DB_CONNECTION=.*#DB_CONNECTION=pgsql#' .env || true
  sed -i.bak -e 's#^DB_HOST=.*#DB_HOST=db#' .env || true
  sed -i.bak -e 's#^DB_PORT=.*#DB_PORT=5432#' .env || true
  sed -i.bak -e 's#^DB_DATABASE=.*#DB_DATABASE=app#' .env || true
  sed -i.bak -e 's#^DB_USERNAME=.*#DB_USERNAME=app#' .env || true
  sed -i.bak -e 's#^DB_PASSWORD=.*#DB_PASSWORD=app#' .env || true
  rm -f .env.bak
fi

# Generate key (idempotent)
docker compose run --rm app php artisan key:generate || true

# Up services
docker compose up -d

echo "\nAll set! Visit http://localhost:8080"