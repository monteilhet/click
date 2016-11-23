#!/bin/bash

cd ~/click
./configure --disable-linuxmodule --enable-all-elements
# NB default install target : /usr/local
sudo make install