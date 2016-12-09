#!/bin/bash

cd ~/click

# ok with kernel 3.x
sudo ./configure --enable-linuxmodule --enable-all-elements

# NB default install target : /usr/local
sudo make install
