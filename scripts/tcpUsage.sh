#!/bin/bash
echo
echo List processes and count of established connections - MUST be run as root:
ss -Hptu |awk '{print $7}' |sort |uniq -c -w25 |sort -r