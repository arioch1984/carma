# Backend Laravel + Docker (OrbStack)

This backend is designed to run locally using Docker containers (compatible with OrbStack) for:
- PHP app (PHP-FPM)
- Web server (Nginx)
- Database (PostgreSQL)

This folder does not yet include the Laravel code: you will generate it with Composer inside a container.

## Requirements
- OrbStack installed (use the `docker` / `docker compose` commands)
- No local PHP/Composer required

## 1) Automatic setup (recommended)
Run from the `backend` folder (macOS/OrbStack):

```bash
chmod +x ./init.sh
./init.sh
```

This script will:
- create the Laravel project (if missing)
- build the app image
- set up `.env` for Postgres in container
- generate `APP_KEY`
- start the services

## 1b) Create the Laravel project manually
Run these commands from the `backend` folder:

```bash
# Scaffold Laravel
docker run --rm -it -v "$PWD":/app -w /app composer:2 \
  composer create-project laravel/laravel .

# Install dependencies (idempotent, if needed)
docker compose run --rm app composer install
```

## 2) Configure the environment (.env)
Edit Laravel's generated `.env` to use PostgreSQL in the container:

```ini
APP_URL=http://localhost:8080

DB_CONNECTION=pgsql
DB_HOST=db
DB_PORT=5432
DB_DATABASE=app
DB_USERNAME=app
DB_PASSWORD=app

CACHE_DRIVER=file
QUEUE_CONNECTION=sync
SESSION_DRIVER=file
```

Then:
```bash
# Generate APP_KEY
docker compose run --rm app php artisan key:generate
```

## 3) Start the services
```bash
docker compose up -d
```

- App available at: http://localhost:8080
- Postgres DB: localhost:5432 (user/pass: app/app, db: app)

## 4) Quick checks
- Test REST route (add to `routes/api.php`):
```php
use Illuminate\Support\Facades\Route;

Route::get('/ping', function () {
    return [
        'pong' => now()->toISOString(),
        'env' => config('app.env'),
        'db' => config('database.default'),
    ];
});
```
Test:
```bash
curl http://localhost:8080/api/ping
```

## 5) GraphQL (optional, Lighthouse)
```bash
docker compose exec app composer require nuwave/lighthouse
# Config and schema
docker compose exec app php artisan vendor:publish --tag=lighthouse-config
docker compose exec app php artisan vendor:publish --tag=lighthouse-schema
```
In `graphql/schema.graphql` add:
```graphql
type Query {
  hello: String! @field(resolver: "App\\GraphQL\\Queries\\Hello@__invoke")
}
```
Create `app/GraphQL/Queries/Hello.php`:
```php
<?php
namespace App\GraphQL\Queries;
class Hello { public function __invoke($_, array $args) { return 'world'; } }
```
Test:
```bash
curl -X POST http://localhost:8080/graphql \
  -H 'Content-Type: application/json' \
  -d '{"query":"{ hello }"}'
```

## 6) Docker files
The main files are already in place:
- `docker-compose.yml`
- `docker/php/Dockerfile`
- `docker/nginx/default.conf`

## 7) Useful commands
- Start/stop: `docker compose up -d`, `docker compose down`
- Logs: `docker compose logs -f web`, `docker compose logs -f app`
- Artisan/Composer: `docker compose exec app php artisan route:list`, `docker compose exec app composer require vendor/package`
- DB: `docker compose exec db psql -U app -d app -c "SELECT NOW();"`
