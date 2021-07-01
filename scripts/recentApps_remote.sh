#!/bin/bash

## recentApps_remote.sh
## list 30 recently started apps on remote system
## assume: ssh server configured in ~/.ssh/ssh_config

remoteHost=192.168.0.255
echo 30 recently started apps on $remoteHost - 
echo 

ssh -t $remoteHost '\
sudo echo ;\
echo start time user comm tty pid ppid %cpu %mem pri class pri psr  ;\
sudo ps -e --sort=-start -o "start time user comm tty pid ppid %cpu %mem pri class pri psr " | tail -n 30  | sort -r ;\
'
