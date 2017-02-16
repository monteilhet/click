#!/bin/bash

# create brctl int-br and ext-br
if [ “$(id -u)” != “0” ]; then printf "\nYou need to be root to run this script!!!\n\n"; exit  ; fi

brctl addbr int-br
brctl addbr ext-br

ip link set int-br up
ip link set ext-br up
