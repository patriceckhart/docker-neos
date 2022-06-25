#!/usr/bin/env bash

envsubst < /root-files/opt/neos/Settings.yaml > /data/neos/Configuration/Settings.yaml
chown www-data:www-data /data/neos/Configuration/Settings.yaml
