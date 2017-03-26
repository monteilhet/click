#!/bin/bash

cd ~/click

#sudo ./configure --enable-linuxmodule --disable-userlevel --enable-all-elements

# to build with kernel > 3.x
#   --enable-ip6 --enable-local
sudo ./configure --enable-linuxmodule --disable-userlevel --with-linux=/usr/src/linux-headers-$(uname -r) --with-linux-map=/boot/System.map-$(uname -r)

sudo sed -i "s/typedef asmlinkage/typedef/" include/click-linuxmodule/include0/asm/syscall.h

# NB default install target : /usr/local
sudo make install

