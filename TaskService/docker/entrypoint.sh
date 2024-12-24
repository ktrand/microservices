#!/bin/sh
set -e

echo "Install dependencies..."
composer install

echo "Run migrations..."
php bin/console doctrine:migrations:migrate

exec "$@"
