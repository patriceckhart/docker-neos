#!/bin/bash

cp /root-files/opt/etc/motd /etc/motd

cp /root-files/opt/neos/cli/cli-flow.sh /usr/local/bin/flow
chmod g+rwx /usr/local/bin/flow

cp /root-files/opt/neos/warmup.sh /usr/local/bin/warmup
chmod g+rwx /usr/local/bin/warmup
