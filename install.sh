#!/bin/bash

sudo apt-get update
sudo apt-get -y install git gcc g++ make

cd ~
git clone https://github.com/kohler/click.git
cd click

git checkout f40363bb492188d44ba2
git tag kernel-3.13