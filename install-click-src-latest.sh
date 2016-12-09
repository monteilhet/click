#!/bin/bash

sudo apt-get update
sudo apt-get -y install git gcc g++ make

cd ~
git clone https://github.com/kohler/click.git
cd click

# Kernel driver no more working after this commit with ubuntu with kernel 3.13
# => patch files for fix
# sed -i "s/linuxmodule)/linuxmodule false)/" elements/linuxmodule/fromhost.cc
sed -i "s/linuxmodule false)/linuxmodule)/" elements/linuxmodule/fromdevice.cc
sed -i "s/extern struct mutex inode_lock;/\/\/extern struct mutex inode_lock;/" linuxmodule/proclikefs.c
sed -i "s/alloc_netdev(0, name, setup)/alloc_netdev(0, name, NET_NAME_UNKNOWN, setup)/" elements/linuxmodule/fromhost.cc
