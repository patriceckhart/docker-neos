#!/bin/bash
set -ex

echo "Start PHP Configuration ..."
echo "date.timezone=${PHP_TIMEZONE:-Europe/Berlin}" > $PHP_INI_DIR/conf.d/date_timezone.ini
echo "memory_limit=${PHP_MEMORY_LIMIT:-1024M}" > $PHP_INI_DIR/conf.d/memory_limit.ini
echo "upload_max_filesize=${PHP_UPLOAD_MAX_FILESIZE:-10M}" > $PHP_INI_DIR/conf.d/upload_max_filesize.ini
echo "post_max_size=${PHP_UPLOAD_MAX_FILESIZE:-10M}" > $PHP_INI_DIR/conf.d/post_max_size.ini
echo "max_execution_time=${PHP_MAX_EXECUTION_TIME:-240}" > $PHP_INI_DIR/conf.d/max_execution_time.ini
echo "max_input_vars=${PHP_MAX_INPUT_VARS:-1500}" > $PHP_INI_DIR/conf.d/max_input_vars.ini
echo "PHP configuration completed."

/usr/local/sbin/php-fpm -y /usr/local/etc/php-fpm.conf -R -D
chmod 066 /var/run/php-fpm.sock
chown www-data:www-data /var/run/php-fpm.sock

su root -c "/root-files/opt/dir.sh"

su root -c "/root-files/opt/ssl.sh"

su root -c "/root-files/opt/cli.sh"

su www-data -c "/root-files/build.sh"

su root -c "/root-files/opt/env.sh"

su www-data -c "/root-files/opt/neos/provisioning.sh"

su root -c "/root-files/opt/crond.sh"

echo "Start configuring sshd ..."

su root -c "/root-files/opt/sshd.sh"

chown -Rf nginx:nginx /var/lib/nginx

echo "Starting services ..."

su root -c "/root-files/opt/nginx/env.sh"

nginx
echo "nginx has started."

postfix start
echo "postfix has started."

/usr/sbin/sshd
echo "sshd has started."

/usr/sbin/crond -S
echo "crond has started."

su www-data -c "/root-files/opt/custom.sh"

echo "Container is up und running."

tail -f /dev/null
#exec "$@"
