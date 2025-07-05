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
sed -i -e "s#listen = 9000#listen = /var/run/php-fpm.sock#" /usr/local/etc/php-fpm.d/zz-docker.conf
echo "clear_env = no" >> /usr/local/etc/php-fpm.d/zz-docker.conf
echo "listen.owner = www-data" >> /usr/local/etc/php-fpm.d/zz-docker.conf
echo "listen.group = www-data" >> /usr/local/etc/php-fpm.d/zz-docker.conf
echo "listen.mode = 0660" >> /usr/local/etc/php-fpm.d/zz-docker.conf
sed -i -e "s#listen = 127.0.0.1:9000#listen = /var/run/php-fpm.sock#" /usr/local/etc/php-fpm.d/www.conf

chown 80:80 -R /var/lib/nginx

apk add --no-cache redis
pecl install redis && docker-php-ext-enable redis
docker-php-ext-install bcmath sysvsem && docker-php-ext-enable bcmath sysvsem

docker-php-ext-install pdo_pgsql

apk add libzip-dev zip
docker-php-ext-install zip

# imagick
git clone https://github.com/Imagick/imagick.git --depth 1 /tmp/imagick
cd /tmp/imagick && git fetch origin master && git switch master
phpize && ./configure && make && make install
docker-php-ext-enable imagick

pecl install vips && echo "extension=vips.so" > /usr/local/etc/php/conf.d/ext-vips.ini && docker-php-ext-enable --ini-name ext-vips.ini vips
pecl install ssh2-1.3.1 && docker-php-ext-enable ssh2
pecl install yaml && echo "extension=yaml.so" > /usr/local/etc/php/conf.d/ext-yaml.ini && docker-php-ext-enable --ini-name ext-yaml.ini yaml

curl -o /tmp/composer-setup.php https://getcomposer.org/installer
php /tmp/composer-setup.php --no-ansi --install-dir=/usr/local/bin --filename=composer --version=${COMPOSER_VERSION}
rm -rf /tmp/composer-setup.php

echo 'StrictHostKeyChecking no' >> /etc/ssh/ssh_config

rm -rf /var/cache/apk/*
apk add tzdata && apk del tzdata
rm -rf /var/cache/apk/*
mkdir -p /run/nginx
