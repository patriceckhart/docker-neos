#!/bin/bash

cd /data/neos && ./flow flow:package:rescan

su root -c "/root-files/opt/neos/cli/cli-permissions.sh"
