#!/bin/bash

if [ ! -z "$1" ]; then
	if [ "$1" == "--force" ]; then
		cd /data/neos && yes | ./flow node:repair		
	fi
else
    cd /data/neos && ./flow node:repair
fi
