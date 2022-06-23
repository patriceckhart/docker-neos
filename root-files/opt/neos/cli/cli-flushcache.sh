#!/bin/bash

cd /data/neos && ./flow flow:cache:flush
cd /data/neos && ./flow flow:cache:flush --force

if [ "$FLOW_CONTEXT" == "Production" ]; then
	su www-data -c "/root-files/opt/neos/cli/cli-warmupcache.sh"
fi

#su www-data -c "/root-files/opt/neos/cli/cli-permissions.sh"
