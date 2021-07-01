#!/bin/bash

## login_remote.sh
## list network stats from remote system
## assume: ssh server configured in ~/.ssh/ssh_config

remoteHost=192.168.0.255
#echo $remoteHost

ssh $remoteHost '\
echo Network stats for $remoteHost - ;
echo ;
echo ss --summary:; ss -sH; \
echo ss --listening --query=inet:; ss -ltuH; \
echo ;\
echo Last 10 logins with reboots etc:; last -10 -F -i -x ;\
'
