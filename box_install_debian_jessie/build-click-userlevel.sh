#!/bin/bash

cd ~/click

sudo ./configure --disable-linuxmodule --enable-all-elements --enable-user-multithread &| tee user-configure.log

# NB default install target : /usr/local
sudo make install &| tee user-build.log
