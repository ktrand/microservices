FROM php:8.2-fpm

RUN apt-get update && apt-get install -y \
    git curl nano zip unzip \
    libpng-dev libonig-dev libxml2-dev libsodium-dev\
    supervisor \
    && pecl install mongodb \
    && docker-php-ext-enable --ini-name 05-opcache.ini opcache mongodb grpc \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN usermod -u 1000 www-data && groupmod -g 1000 www-data \
    && usermod -s /bin/bash www-data

ENV COMPOSER_ALLOW_SUPERUSER=1

WORKDIR /var/www/app

COPY --from=composer:2.8.2 /usr/bin/composer /usr/bin/composer

RUN mkdir -p /var/log/supervisor /var/www/app \
    && chown -R www-data:www-data /var/log/supervisor /var/www/app

COPY TaskService/docker/supervisord.conf /etc/supervisor/supervisord.conf
COPY TaskService/docker/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

USER www-data

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["supervisord", "-c", "/etc/supervisor/supervisord.conf"]