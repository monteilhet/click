#!/bin/bash

# create a demo brctl demo-br
if [ “$(id -u)” != “0” ]; then printf "\nYou need to be root to run this script!!!\n\n"; exit  ; fi

echo 1 > /proc/sys/net/ipv4/ip_forward
echo 1 > /proc/sys/net/ipv6/conf/all/forwarding
