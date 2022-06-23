#!/bin/bash

GITFILE=/data/neos/.git
PULLEDFILE=/data/.pulled
BUILTFILE=/data/.built

if [ ! -z "${GITHUB_TOKEN+xxx}" ]; then

	composer config -g github-oauth.github.com $GITHUB_TOKEN

fi

if [ ! -z "${GITHUB_REPOSITORY+xxx}" ]; then

	if [ ! -e "$PULLEDFILE" ]; then

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

		composer clear-cache --no-interaction

		if [ "$FLOW_CONTEXT" == "Production" ]; then
			cd /data/neos && composer install --no-dev --no-interaction
		else
			cd /data/neos && composer install --no-interaction
		fi

		touch /data/.built

	fi

fi
