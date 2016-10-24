#! /bin/bash

### run this script to check if click is installed

printf "\nClick Kernel-level\n"
printf "==================\n"
find /usr/local/sbin/ -name "click*"
find /usr/local/lib/ -name "*.ko"
printf "\n"
click-install --version

printf "\nClick User-level application\n"
printf "============================\n"
find /usr/local/bin/ -name "click*"
printf "\n"
click --version

printf "\nClicky tool\n"
printf "============================\n"
find /usr/local/bin/ -name "clicky*"
printf "\n"
clicky --version
