#!/bin/bash

cd ~/click/apps/clicky
sudo apt-get -y install autoconf libgtk2.0-dev graphviz
autoreconf -i
./configure
sudo make install

