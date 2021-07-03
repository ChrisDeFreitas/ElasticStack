#!/bin/bash

## services_remote.sh
## list enabled services/daemons on remote system
## assume: ssh server configured in ~/.ssh/config

remoteHost=$1

if [ -z "$remoteHost" ];
then
  #remoteHost=192.168.0.255
  echo "  Error: arg1 must be server name or ip."
  exit -1
fi

echo Enabled services on $remoteHost -
echo

ssh -t $remoteHost 'sudo systemctl list-unit-files --type=service | grep enabled'

