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


printf "\nCheck Click Kernel module\n"
if [[ `lsmod | grep click` ]] ; then
  printf "> click module is loaded\n"
else printf "click is not running at kernel\n" ; exit 1; fi

if [[ `grep click /proc/mounts` ]] ; then
printf "> click fs is mounted\n"
else printf "click is not running at kernel" ; exit 1; fi

printf "> click config :\n"
cat /proc/click/config
