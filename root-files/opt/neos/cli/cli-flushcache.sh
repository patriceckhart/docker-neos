#!/bin/bash

cd /data/neos && ./flow flow:cache:flush
cd /data/neos && ./flow flow:cache:flush --force

if [ ! -z "$1" ]; then
	if [ "$1" == "--removetempdir" ]; then

		rm -rf /data/neos/Data/Temporary

	fi
fi

su root -c "/root-files/opt/neos/cli/cli-warmupcache.sh"

su root -c "/root-files/opt/neos/cli/cli-permissions.sh"
