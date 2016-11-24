#!/bin/bash

# run configuration using local ip for pc1 =>  promisc use is not required

sudo click  -p 3333  LOCALIP=192.168.56.20 LOCALMAC=08:00:27:3e:30:93 REMOTEIP=192.168.56.21 PROMISC=false pc1.click