#!/bin/bash

cd ~/click

# ok with kernel 3.x :
# install source with install-click-src.sh
# build userlevel and kernel engine
sudo ./configure --enable-linuxmodule --enable-all-elements

# NB default install target : /usr/local
sudo make install
