#!/bin/bash

cd ~/click

# https://github.com/kohler/click/issues/184
# => create  /usr/src/linux-headers-$(uname -r)-merged by copying /usr/src/linux-headers-$(uname -r)  /usr/src/linux-headers-xxx-common

# to build with kernel 3.x
#    --enable-local
sudo ./configure --enable-linuxmodule --enable-ip6 --with-linux=/usr/src/linux-headers-$(uname -r)-merged --with-linux-map=/boot/System.map-$(uname -r)

# sudo sed -i "s/typedef asmlinkage/typedef/" include/click-linuxmodule/include0/asm/syscall.h

# NB default install target : /usr/local
sudo make install

