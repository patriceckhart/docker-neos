#!/bin/bash

FLOWTEMPDIR="/tmp/Flow_Temporary"

if [ ! -d "$FLOWTEMPDIR" ]; then
  mkdir /tmp/Flow_Temporary
fi

rm -rf /data/neos/Data/Temporary
ln -s /tmp/Flow_Temporary /data/neos/Data/Temporary

chown -R www-data:www-data /tmp/Flow_Temporary
chmod -R g+rwx /tmp/Flow_Temporary
