#!/bin/bash

data=${1-OOOO}

echo "send $data to pc1"

echo -n $data | nc -4u -q1 192.168.56.20 1234


