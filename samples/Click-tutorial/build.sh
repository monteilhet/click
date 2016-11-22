#/bin/bash

# copy source files
cp elements/local/* ~/click/elements/local

cd ~/click
./configure --disable-linuxmodule --enable-all-elements
sudo make install