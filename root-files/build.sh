#!/bin/sh
set -ex

apk update
apk add bash nano gettext git nginx tar curl postfix mariadb-client optipng freetype libjpeg-turbo-utils icu-dev vips-dev vips-tools openssh pwgen build-base
apk add --virtual libtool freetype-dev libpng-dev libjpeg-turbo-dev yaml-dev libssh2-dev
apk add --no-cache nginx nginx-mod-http-headers-more

docker-php-ext-configure gd --with-freetype --with-jpeg
docker-php-ext-install gd pdo pdo_mysql opcache intl exif

apk add --no-cache --virtual .deps imagemagick imagemagick-libs imagemagick-dev imagemagick-pdf ghostscript autoconf postgresql-dev

deluser www-data || true
delgroup cdrw || true
addgroup -g 80 www-data
adduser -u 80 -G www-data -s /bin/bash -D www-data -h /data
rm -Rf /home/www-data

# PHP-FPM Config
echo "listen = /var/run/php-fpm.sock" >> /usr/local/etc/php-fpm.d/zz-docker.conf
echo "clear_env = no" >> /usr/local/etc/php-fpm.d/zz-docker.conf
echo "listen.owner = www-data" >> /usr/local/etc/php-fpm.d/zz-docker.conf
echo "listen.group = www-data" >> /usr/local/etc/php-fpm.d/zz-docker.conf
echo "listen.mode = 0660" >> /usr/local/etc/php-fpm.d/zz-docker.conf

chown 80:80 -R /var/lib/nginx

apk add --no-cache redis
docker-php-source extract
curl -fsSL --retry 5 https://github.com/phpredis/phpredis/archive/refs/tags/6.3.0.tar.gz | tar xz -C /usr/src/php/ext && mv /usr/src/php/ext/phpredis-6.3.0 /usr/src/php/ext/redis
curl -fsSL --retry 5 https://github.com/Imagick/imagick/archive/refs/tags/3.8.1.tar.gz | tar xz -C /usr/src/php/ext && mv /usr/src/php/ext/imagick-3.8.1 /usr/src/php/ext/imagick
curl -fsSL --retry 5 https://github.com/libvips/php-vips-ext/archive/b05b5c5ac4de172bd3fb0d1cfe063384a94cedbb.tar.gz | tar xz -C /usr/src/php/ext && mv /usr/src/php/ext/php-vips-ext-b05b5c5ac4de172bd3fb0d1cfe063384a94cedbb /usr/src/php/ext/vips
curl -fsSL --retry 5 https://github.com/php/pecl-networking-ssh2/archive/refs/tags/1.5.0.tar.gz | tar xz -C /usr/src/php/ext && mv /usr/src/php/ext/pecl-networking-ssh2-1.5.0 /usr/src/php/ext/ssh2
curl -fsSL --retry 5 https://github.com/php/pecl-file_formats-yaml/archive/refs/tags/2.3.0.tar.gz | tar xz -C /usr/src/php/ext && mv /usr/src/php/ext/pecl-file_formats-yaml-2.3.0 /usr/src/php/ext/yaml
docker-php-ext-install redis
docker-php-ext-install bcmath sysvsem && docker-php-ext-enable bcmath sysvsem

docker-php-ext-install pdo_pgsql

apk add libzip-dev zip
docker-php-ext-install zip

docker-php-ext-install imagick
CFLAGS="-Wno-error=incompatible-pointer-types -Wno-error=implicit-function-declaration -Wno-error=int-conversion" docker-php-ext-install vips
docker-php-ext-install ssh2
docker-php-ext-install yaml
docker-php-source delete
cd /tmp

curl -o /tmp/composer-setup.php https://getcomposer.org/installer
php /tmp/composer-setup.php --no-ansi --install-dir=/usr/local/bin --filename=composer --version=${COMPOSER_VERSION}
rm -rf /tmp/composer-setup.php

echo 'StrictHostKeyChecking no' >> /etc/ssh/ssh_config

rm -rf /var/cache/apk/*
apk add tzdata && apk del tzdata
rm -rf /var/cache/apk/*
mkdir -p /run/nginx
