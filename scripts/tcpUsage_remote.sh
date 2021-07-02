#!/bin/bash

## tcpUsage_remote.sh
## list processes and count of established connections on remote system
## assume: ssh server configured in ~/.ssh/ssh_config

remoteHost=$1

if [ -z "$remoteHost" ];
then
	#remoteHost=192.168.0.255
  echo "  Error: arg1 must be server name or ip (arg1 = $remoteHost)."
  exit -1
fi

echo List processes and count of established connections on $remoteHost - 
echo 

ssh -t $remoteHost 'sudo ss -Hptu |awk "{print $7}" |sort |uniq -c -w25 |sort -r '
