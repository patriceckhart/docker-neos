set -e

openssl req -x509 -nodes -days 365 -subj "/C=CA/ST=QC/O=docker-neos./CN=localhost.local" -addext "subjectAltName=DNS:localhost.local" -newkey rsa:2048 -keyout /etc/ssl/private/nginx-selfsigned.key -out /etc/ssl/certs/nginx-selfsigned.crt;
