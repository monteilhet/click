#! /bin/bash

### run this script to check if a kernel click configuration is installed

printf "\nClick Kernel-level\n"
printf "==================\n"
find /usr/local/sbin/ -name "click*"
find /usr/local/lib/ -name "*.ko"
printf "\n"
click-install --version

### if click kernel driver is running => :
### - click module is loaded
### - /proc/click symbolic link exists and points to /click
### - /click filesystem is mounted
### - a click configuration is written in /proc/click/config

if [ "$(id -u)" != "0" ]; then printf "\nYou need to be root to run this script!!!\n\n"; exit  ; fi


printf "\nClick Kernel module\n"
lsmod | grep click

printf "\nClick fs is mount\n"
grep click /proc/mounts

cat /proc/click/config
