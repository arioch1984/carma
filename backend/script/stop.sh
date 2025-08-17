#!/usr/bin/env bash
set -euo pipefail

# Resolve backend directory (parent of this script dir)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKEND_DIR="${SCRIPT_DIR%/script}"
cd "$BACKEND_DIR"

# Stop and remove containers (keep volumes by default)
if [[ "${1:-}" == "-v" || "${1:-}" == "--volumes" ]]; then
  echo "Stopping containers and removing volumes..."
  docker compose down -v
else
  echo "Stopping containers (volumes preserved). Use -v to remove volumes."
  docker compose down
fi

echo "Containers stopped."