# Carma Project

This repository contains the Carma project. It is organized into separate folders for backend and frontend. The backend is a Laravel application intended to run locally via Docker (optimized for OrbStack). The frontend folder is present as a placeholder for future work.

## Repository structure
- backend/ — Laravel backend scaffold and Docker setup (PHP-FPM, Nginx, PostgreSQL)
- frontend/ — Frontend application (placeholder)

## Getting started (backend)
1) Navigate to the backend folder:
```bash
cd backend
```
2) Run the automatic setup (no local PHP/Composer required):
```bash
chmod +x ./init.sh
./init.sh
```
This will create the Laravel project (if missing), configure the environment, and start the containers.

- App: http://localhost:8080
- Database: Postgres on localhost:5432 (user/pass: app/app, db: app)

For full backend instructions, see backend/README.md.

## Requirements
- macOS with OrbStack (or any Docker runtime). OrbStack is recommended for performance on macOS.
- Docker and Docker Compose available in your shell (OrbStack provides compatible commands).

## Development notes
- Changes to the backend code are mounted into the container, so edits on the host are reflected live.
- Logs:
  - Nginx: `docker compose -f backend/docker-compose.yml logs -f web`
  - PHP-FPM: `docker compose -f backend/docker-compose.yml logs -f app`
- Artisan and Composer inside the app container:
  - `docker compose -f backend/docker-compose.yml exec app php artisan route:list`
  - `docker compose -f backend/docker-compose.yml exec app composer install`

## License
Add your project license here (e.g., MIT).