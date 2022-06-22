#!/bin/bash

if [ "$FLOW_CONTEXT" == "Production" ]; then
	cd /data/neos && composer install --no-dev --no-interaction
else
	cd /data/neos && composer install --no-interaction
fi

cd /data/neos && ./flow flow:core:setfilepermissions

su www-data -c "/root-files/opt/neos/cli/cli-packagerescan.sh"

if [ ! -z "$1" ]; then
	if [ "$1" == "--force" ]; then

		su www-data -c "/root-files/opt/neos/cli/cli-doctrinemigrate.sh"
		su www-data -c "/root-files/opt/neos/cli/cli-doctrineupdate.sh"
		su www-data -c "/root-files/opt/neos/cli/cli-noderepair.sh"

	fi
fi

su www-data -c "/root-files/opt/neos/cli/cli-flushcache.sh"
