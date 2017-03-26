#!/bin/bash

cd ~/click

# build with kernel > 3.x
# --disable-userlevel
sudo ./configure --enable-linuxmodule --disable-userlevel --enable-multithread --enable-ip6 --with-linux=/usr/src/linux-headers-$(uname -r) --with-linux-map=/boot/System.map-$(uname -r)

sudo sed -i "s/typedef asmlinkage/typedef/" include/click-linuxmodule/include0/asm/syscall.h

# NB default install target : /usr/local
sudo make install

