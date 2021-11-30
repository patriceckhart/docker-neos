#!/usr/bin/env bash

export DOLLAR='$'
envsubst < /root-files/opt/nginx/etc/neos.conf.template > /etc/nginx/http.d/default.conf
