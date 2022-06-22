set -e

if [ ! -e "$FLOW_PATH_TEMPORARY_BASE" ]; then

	if [ ! -d "$FLOW_PATH_TEMPORARY_BASE" ]; then

		mkdir -p $FLOW_PATH_TEMPORARY_BASE

		chown -R www-data:www-data $FLOW_PATH_TEMPORARY_BASE
    chmod -R g+rwx $FLOW_PATH_TEMPORARY_BASE

	fi

fi

CONFDIR="/data/neos/Configuration"

if [ ! -d "$CONFDIR" ]; then

	mkdir -p $CONFDIR

	chown -R www-data:www-data $CONFDIR
  chmod -R g+rwx $CONFDIR

fi
