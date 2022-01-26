#!/bin/bash

PROVISIONINGFILE=/data/.provisioned

if [ ! -z ${RUN_DOCTRINE_MIGRATE+x} ]; then

	echo "Migrate database ..."

	su root -c "/root-files/opt/neos/cli/cli-doctrinemigrate.sh"
	su root -c "/root-files/opt/neos/cli/cli-permissions.sh"

fi

if [ ! -z ${RUN_DOCTRINE_UPDATE+x} ]; then

	echo "Update database ..."

	su root -c "/root-files/opt/neos/cli/cli-doctrineupdate.sh"
	su root -c "/root-files/opt/neos/cli/cli-permissions.sh"

fi

if [ ! -z ${RUN_FLUSHCACHE+x} ]; then

	echo "Flushing cache ..."

	su root -c "/root-files/opt/neos/cli/cli-flushcache.sh"
	su root -c "/root-files/opt/neos/cli/cli-permissions.sh"

fi

if [ ! -z ${SITE_PACKAGE+x} ]; then 

	if [ ! -e "$PROVISIONINGFILE" ]; then

		echo "Provisioning Neos ..."

		su root -c "/root-files/opt/neos/cli/cli-flushcache.sh"

		cd /data/neos && ./flow site:import --package-key ${SITE_PACKAGE}

		touch /data/.provisioned

		su root -c "/root-files/opt/neos/cli/cli-permissions.sh"

	fi

fi
