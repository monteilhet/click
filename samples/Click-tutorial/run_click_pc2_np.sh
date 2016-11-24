#!/bin/bash

# run configuration using local ip for pc2 => promisc use is not required

sudo click  -p 3333  LOCALIP=192.168.56.21 LOCALMAC=08:00:27:26:ea:fb PROMISC=false REMOTEIP=192.168.56.20 pc2.click