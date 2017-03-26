#!/bin/bash

# run userlevel click configuration to proxy handler requests to the kernel handlers
printf "run click kproxy.click\n"
click /vagrant/samples/usermode/kproxy.click &
ps -ef | grep kproxy | grep -v grep

printf "use telnet localhost 35500\n\n" 
printf "> read config\n"
printf "> read list\n"
