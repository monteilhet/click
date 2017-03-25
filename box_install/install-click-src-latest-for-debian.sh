#!/bin/bash

sudo apt-get update
sudo apt-get -y install git gcc g++ make

cd ~
git clone https://github.com/kohler/click.git
cd click

# Kernel driver with ubuntu with kernel 4.x => patch files for fix
# sed -i "s/linuxmodule)/linuxmodule false)/" elements/linuxmodule/fromhost.cc
sed -i "s/linuxmodule false)/linuxmodule)/" elements/linuxmodule/fromdevice.cc
#sed -i "s/extern struct mutex inode_lock;/\/\/extern struct mutex inode_lock;/" linuxmodule/proclikefs.c
#sed -i "s/alloc_netdev(0, name, setup)/alloc_netdev(0, name, NET_NAME_UNKNOWN, setup)/" elements/linuxmodule/fromhost.cc


# https://github.com/kohler/click/issues/184
# => create  /usr/src/linux-headers-$(uname -r)-merged by copying /usr/src/linux-headers-$(uname -r)  /usr/src/linux-headers-xxx-common
sudo cp -a /usr/src/linux-headers-$(uname -r) /usr/src/linux-headers-$(uname -r)-merged
sudo cp -r /usr/src/linux-headers-$(uname -r | sed -r "s/-[a-z0-9]+$//")-common/*  /usr/src/linux-headers-$(uname -r)-merged

