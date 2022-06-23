#!/bin/bash

if [ -f "/data/neos/startup.sh" ]; then

	echo "Run custom startup.sh from repository ..."

	sh /data/neos/startup.sh

fi