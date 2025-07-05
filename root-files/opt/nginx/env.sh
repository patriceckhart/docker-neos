#!/usr/bin/env bash

mkdir -p /tmp/nginx/{client_body,proxy,fastcgi,scgi,uwsgi}

export DOLLAR='$'
envsubst < /root-files/opt/nginx/etc/mime.types.template > /etc/nginx/mime.types
envsubst < /root-files/opt/nginx/etc/nginx.conf.template > /etc/nginx/nginx.conf
envsubst < /root-files/opt/nginx/etc/http.d/neos.conf.template > /etc/nginx/http.d/neos.conf
