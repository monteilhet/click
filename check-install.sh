#! /bin/bash
RED="\x1b[1;31m"
GREEN="\x1b[1;32m"
DEF="\x1b[0m"


### run this script to check if click is installed

printf "\nClick Kernel-level\n"
printf "==================\n"
find /usr/local/sbin/ -name "click*"
find /usr/local/lib/ -name "*.ko"
printf "\n"
click-install --version
if [ $? -ne 0 ]; then
  printf "\n${RED} click in kernel mode is not installed${DEF}\n"
else
  printf "\n${GREEN} click in kernel mode is installed${DEF}\n"
fi

printf "\nClick User-level application\n"
printf "============================\n"
find /usr/local/bin/ -name "click*"
printf "\n"
click --version
if [ $? -ne 0 ]; then
  printf "\n${RED} click in user mode is not installed${DEF}\n"
else
  printf "\n${GREEN} click in user mode is installed${DEF}\n"
fi


printf "\nClicky tool\n"
printf "============================\n"
find /usr/local/bin/ -name "clicky*"
printf "\n"
clicky --version
if [ $? -ne 0 ]; then
  printf "\n${RED} clicky tool is not installed${DEF}\n"
else
  printf "\n${GREEN} clicky tool is installed${DEF}\n"
fi
