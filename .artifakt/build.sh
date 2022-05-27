#!/bin/bash

set -e
echo ">>>>>>>>>>>>>> START CUSTOM BUILD SCRIPT <<<<<<<<<<<<<<<<< "

export APP_ENV=dev
export APP_DEBUG=1

# apply configuration files and patches for Sylius Plus
cp -rp /.artifakt/config/* /var/www/html/config || true
cp /.artifakt/config/bundles.php /var/www/html/config/bundles.php

mkdir -p /var/www/html/src/Entity/Order && cp /.artifakt/src/Entity/Order/Order.php /var/www/html/src/Entity/Order/
mkdir -p /var/www/html/src/Entity/User && cp /.artifakt/src/Entity/User/AdminUser.php /var/www/html/src/Entity/User/
mkdir -p /var/www/html/src/Entity/Channel && cp /.artifakt/src/Entity/Channel/Channel.php /var/www/html/src/Entity/Channel/
mkdir -p /var/www/html/src/Entity/Shipping && cp /.artifakt/src/Entity/Shipping/Shipment.php /var/www/html/src/Entity/Shipping/
mkdir -p /var/www/html/src/Entity/Customer && cp /.artifakt/src/Entity/Customer/Customer.php /var/www/html/src/Entity/Customer/
mkdir -p /var/www/html/src/Entity/Product && cp /.artifakt/src/Entity/Product/ProductVariant.php /var/www/html/src/Entity/Product/

# additional packages
# acl used by entrypoint to init JWT
# wkhtmltopdf used for invoicing plugin
apt-get update && \
    apt-get install -y -q --no-install-recommends acl wkhtmltopdf && \
    rm -rf /var/lib/apt/lists/*

composer config repositories.plus composer https://sylius.repo.packagist.com/artifakt-io/
composer config --global --auth http-basic.sylius.repo.packagist.com token $COMPOSER_TOKEN

# NO SCRIPTS, it breaks the build
# see https://stackoverflow.com/a/61349991/1093649
composer install --no-cache --optimize-autoloader --no-interaction --no-ansi --no-scripts

echo "export APP_ENV=$APP_ENV" >> /etc/apache2/envvars
echo "export APP_DEBUG=$APP_DEBUG" >> /etc/apache2/envvars

rm -rf /var/www/html/var/ && \
    mkdir -p /data/var/ && \
    ln -s /data/var/ /var/www/html/var

rm -rf /var/www/html/var/cache && \
    mkdir -p /data/var/cache && \
    ln -s /data/var/cache /var/www/html/var/cache

chown -R www-data:www-data /var/www/html /data/var
chmod 755 /var/www/html/bin/console

echo ">>>>>>>>>>>>>> END CUSTOM BUILD SCRIPT <<<<<<<<<<<<<<<<< "
