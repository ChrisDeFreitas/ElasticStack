#!/bin/bash

echo 
echo ss --summary:
ss -sH

echo ss --listening --query=inet:
ss -ltuH

echo 
echo Last 10 logins with reboots etc:
last -10 -F -i -x

