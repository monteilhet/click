#!/bin/bash

sudo apt-get update
sudo apt-get -y install git gcc g++ make

cd ~
git clone https://github.com/kohler/click.git
cd click

# reactivate fromdevice element
sed -i "s/linuxmodule false)/linuxmodule)/" elements/linuxmodule/fromdevice.cc


# https://github.com/kohler/click/issues/184
# => create  /usr/src/linux-headers-$(uname -r)-merged by copying /usr/src/linux-headers-$(uname -r)  /usr/src/linux-headers-xxx-common
sudo cp -a /usr/src/linux-headers-$(uname -r) /usr/src/linux-headers-$(uname -r)-merged
sudo cp -r /usr/src/linux-headers-$(uname -r | sed -r "s/-[a-z0-9]+$//")-common/*  /usr/src/linux-headers-$(uname -r)-merged

