#!/bin/bash

cd ~/click

sudo ./configure --enable-linuxmodule --enable-all-elements
# NB default install target : /usr/local
sudo make install
