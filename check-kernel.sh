#! /bin/bash
RED="\x1b[1;31m"
BROWN="\x1b[0;33m"
DEF="\x1b[0m"



### run this script to check if a kernel click configuration is installed

printf "\nClick Kernel-level\n"
printf "==================\n"
find /usr/local/sbin/ -name "click*"
find /usr/local/lib/ -name "*.ko"
printf "\n"
click-install --version
if [ $? -ne 0 ]; then
  printf "\n${RED} click in kernel mode is not installed${DEF}\n"
  exit 1
fi

### if click kernel driver is running => :
### - click module is loaded
### - /proc/click symbolic link exists and points to /click
### - /click filesystem is mounted
### - a click configuration is written in /proc/click/config


printf "\nCheck Click Kernel module\n"
if [[ `lsmod | grep click` ]] ; then
  printf "> click module is loaded\n"
else printf "${BROWN} click is not running at kernel${DEF}\n" ; exit 1; fi

if [[ `ls /proc | grep click` ]] ; then
  printf "> /proc/click symbolic link exists and points to /click\n"
fi

if [[ `grep click /proc/mounts` ]] ; then
printf "> click fs is mounted\n"
else printf "click is not running at kernel" ; exit 1; fi

printf "> click config :\n"
cat /proc/click/config
