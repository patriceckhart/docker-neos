#!/bin/bash

PROVISIONINGFILE=/data/.provisioned

if [ ! -z ${RUN_DOCTRINE_MIGRATE+x} ]; then

	echo "Migrate database ..."

	doctrinemigrate

fi

if [ ! -z ${RUN_DOCTRINE_UPDATE+x} ]; then

	echo "Update database ..."

	doctrineupdate

fi

if [ ! -z ${RUN_FLUSHCACHE+x} ]; then

	echo "Flushing cache ..."

	flushcache

fi

if [ ! -z ${SITE_PACKAGE+x} ]; then

	if [ ! -e "$PROVISIONINGFILE" ]; then

		echo "Provisioning Neos ..."

		flushcache

		cd /data/neos && ./flow site:import --package-key ${SITE_PACKAGE}

		touch /data/.provisioned

	fi

fi
