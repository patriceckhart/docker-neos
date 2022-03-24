#!/bin/bash

cp /root-files/opt/etc/motd /etc/motd

cp /root-files/opt/neos/cli/cli-flow.sh /usr/local/bin/flow
chmod g+rwx /usr/local/bin/flow

cp /root-files/opt/neos/cli/git/cli-pullapp.sh /usr/local/bin/pullapp
chmod g+rwx /usr/local/bin/pullapp

cp /root-files/opt/neos/cli/cli-flushcache.sh /usr/local/bin/flushcache
chmod g+rwx /usr/local/bin/flushcache

cp /root-files/opt/neos/cli/cli-packagerescan.sh /usr/local/bin/packagerescan
chmod g+rwx /usr/local/bin/packagerescan

cp /root-files/opt/neos/cli/cli-noderepair.sh /usr/local/bin/noderepair
chmod g+rwx /usr/local/bin/noderepair

cp /root-files/opt/neos/cli/cli-installneos.sh /usr/local/bin/installneos
chmod g+rwx /usr/local/bin/installneos

cp /root-files/opt/neos/cli/cli-updateneos.sh /usr/local/bin/updateneos
chmod g+rwx /usr/local/bin/updateneos

cp /root-files/opt/neos/cli/cli-doctrinemigrate.sh /usr/local/bin/doctrinemigrate
chmod g+rwx /usr/local/bin/doctrinemigrate

cp /root-files/opt/neos/cli/cli-doctrineupdate.sh /usr/local/bin/doctrineupdate
chmod g+rwx /usr/local/bin/doctrineupdate

cp /root-files/opt/neos/cli/cli-silent.sh /usr/local/bin/silent
chmod g+rwx /usr/local/bin/silent

cp /root-files/opt/neos/cli/cli-permissions.sh /usr/local/bin/setpermissions
chmod g+rwx /usr/local/bin/setpermissions
