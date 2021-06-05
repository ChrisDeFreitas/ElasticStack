#!/bin/bash
echo
echo 30 recently started apps - MUST be run as root:
echo
echo start time user comm tty pid ppid %cpu %mem pri class pri psr 
ps -e --sort=-start -o "start time user comm tty pid ppid %cpu %mem pri class pri psr " | tail -n 30  | sort -r