FROM php:8.3-fpm-alpine

# Estensioni utili per Laravel + Postgres
RUN apk add --no-cache bash git curl zip unzip icu-dev oniguruma-dev libpng-dev libjpeg-turbo-dev libzip-dev postgresql-dev \
    && docker-php-ext-configure gd --with-jpeg \
    && docker-php-ext-install -j$(nproc) intl mbstring gd exif pcntl bcmath opcache zip pdo_pgsql

# Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Migliora performance dev
RUN echo "memory_limit=512M" > /usr/local/etc/php/conf.d/memory-limit.ini \
    && echo "opcache.enable=1" > /usr/local/etc/php/conf.d/opcache.ini \
    && echo "opcache.enable_cli=1" >> /usr/local/etc/php/conf.d/opcache.ini

WORKDIR /var/www/html

# Utente non-root (opzionale): mappa all'UID/GID 1000 (tipico macOS/OrbStack)
RUN addgroup -g 1000 app && adduser -D -G app -u 1000 app
USER app

CMD ["php-fpm"]
