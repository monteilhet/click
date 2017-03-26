#!/bin/bash

cd ~/click

# https://github.com/kohler/click/issues/184
# => create  /usr/src/linux-headers-$(uname -r)-merged by copying /usr/src/linux-headers-$(uname -r)  /usr/src/linux-headers-xxx-common

# build with kernel 3.x
sudo ./configure --enable-linuxmodule --disable-userlevel --enable-multithread --enable-ip6 --with-linux=/usr/src/linux-headers-$(uname -r)-merged --with-linux-map=/boot/System.map-$(uname -r)

# NB default install target : /usr/local
sudo make install

