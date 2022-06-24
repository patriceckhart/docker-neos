#!/bin/bash

if [ -f "/data/neos/startup-root.sh" ]; then

	echo "Run custom startup-root.sh from repository ..."

	sh /data/neos/startup-root.sh

fi