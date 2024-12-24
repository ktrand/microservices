FROM php:8.2-fpm

RUN apt-get update && apt-get install -y \
    git curl nano zip unzip \
    libpng-dev libonig-dev libxml2-dev libsodium-dev \
    supervisor build-essential autoconf libtool pkg-config \
    libgrpc-dev protobuf-compiler \
    && apt-get clean && rm -rf /var/lib/apt/lists/* \

ENV MAKEFLAGS=" -j 4"

RUN git clone --depth 1 -b v1.56.0 https://github.com/grpc/grpc /tmp/grpc && \
    cd /tmp/grpc && \
    git submodule update --init && \
    cd src/php/ext/grpc && \
    phpize && \
    ./configure && \
    make && \
    make install && \
    echo "extension=grpc.so" > /usr/local/etc/php/conf.d/grpc.ini && \
    rm -rf /tmp/grpc

RUN pecl install mongodb && \
    docker-php-ext-enable --ini-name 05-opcache.ini opcache mongodb

RUN usermod -u 1000 www-data && groupmod -g 1000 www-data \
    && usermod -s /bin/bash www-data

ENV COMPOSER_ALLOW_SUPERUSER=1

WORKDIR /var/www/app
COPY --from=composer:2.8.2 /usr/bin/composer /usr/bin/composer

RUN mkdir -p /var/log/supervisor /var/www/app \
    && chown -R www-data:www-data /var/log/supervisor /var/www/app

COPY UserService/docker/supervisord.conf /etc/supervisor/supervisord.conf
COPY UserService/docker/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

USER www-data
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["supervisord", "-c", "/etc/supervisor/supervisord.conf"]
