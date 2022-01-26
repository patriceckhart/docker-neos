#!/bin/bash

GITFILE=/data/neos/.git
PULLEDFILE=/data/.pulled
BUILTFILE=/data/.built

if [ ! -e "$GITHUB_REPOSITORY" ]; then

	if [ ! -e "$PULLEDFILE" ]; then

		composer clear-cache --no-interaction

		if [ -z ${GITHUB_TOKEN+x} ]; then 

			if [ ! -e "$GITFILE" ]; then
				git clone $GITHUB_REPOSITORY /data/neos
			else 
				git pull $GITHUB_REPOSITORY /data/neos
			fi
			
		else

			if [ ! -e "$GITFILE" ]; then

				cd /data/neos && git init
				cd /data/neos && git remote add origin https://$GITHUB_USERNAME:$GITHUB_TOKEN@github.com/$GITHUB_USERNAME/$GITHUB_REPOSITORY
				cd /data/neos && git fetch

				if [ ! -e "$GITHUB_REPOSITORY_BRANCH" ]; then

					cd /data/neos && git checkout -t origin/$GITHUB_REPOSITORY_BRANCH

				else

					cd /data/neos && git checkout -t origin/master

				fi

			else
				git pull https://$GITHUB_USERNAME:$GITHUB_TOKEN@github.com/$GITHUB_USERNAME/$GITHUB_REPOSITORY /data/neos
			fi 

		fi

		touch /data/.pulled

	fi

	if [ ! -f "$BUILTFILE" ]; then

		cd /data/neos && composer install --no-dev --no-interaction

		touch /data/.built

	fi

	composer config -g github-oauth.github.com $GITHUB_TOKEN

fi

su root -c "/root-files/opt/env.sh"

su root -c "/root-files/opt/neos/provisioning.sh"

su root -c "/root-files/opt/neos/cli/cli-permissions.sh"
