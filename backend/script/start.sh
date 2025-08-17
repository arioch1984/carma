#!/usr/bin/env bash
set -euo pipefail

# Resolve backend directory (parent of this script dir)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKEND_DIR="${SCRIPT_DIR%/script}"
cd "$BACKEND_DIR"

# Build app image if not built yet (optional, safe)
docker compose build app

# Start all services in detached mode
docker compose up -d

echo "Containers started. App: http://localhost:8080"