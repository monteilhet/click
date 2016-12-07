#!/bin/bash

sudo apt-get install arping

sudo apt-get install wireshark
sudo groupadd wireshark
sudo usermod -a -G wireshark vagrant
sudo chgrp wireshark /usr/bin/dumpcap
sudo chmod 750 /usr/bin/dumpcap
sudo setcap cap_net_raw,cap_net_admin=eip /usr/bin/dumpcap
sudo getcap /usr/bin/dumpcap


