#!/bin/bash

cd ~/click

sudo ./configure --enable-linuxmodule --disable-userlevel --enable-all-elements 
# NB default install target : /usr/local
sudo make install

