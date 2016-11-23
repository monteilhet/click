#!/bin/bash

sudo apt-get install -y default-jdk

cd ~/click/apps/ClickController

javac -d . *.java

