#!/bin/bash

echo "Start pulling the git repository ... "

cd /data/neos && git reset --hard

if [ -z ${GITHUB_TOKEN+x} ]; then
	cd /data/neos && git pull $GITHUB_REPOSITORY
else
	cd /data/neos && git pull https://$GITHUB_USERNAME:$GITHUB_TOKEN@github.com/$GITHUB_USERNAME/$GITHUB_REPOSITORY
fi

if [ ! -z "$1" ]; then
	if [ "$1" == "--force" ]; then

        su www-data -c "/root-files/opt/neos/cli/cli-doctrinemigrate.sh"
		su www-data -c "/root-files/opt/neos/cli/cli-doctrineupdate.sh"
		su www-data -c "/root-files/opt/neos/cli/cli-noderepair.sh"

	fi
fi

su www-data -c "/root-files/opt/neos/cli/cli-flushcache.sh"

echo "Git repository was pulled successfully."
