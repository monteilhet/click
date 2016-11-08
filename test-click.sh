

printf "\nClick User-level test\n"
printf "=======================\n"
click /vagrant/samples/usermode/test.click

sudo click /vagrant/samples/usermode/test-device-block.click


printf "\nClick kernel test\n"
printf "===================\n"

sudo click-install /vagrant/samples/kernelmode/test-device-block.click

# test ping will not reply
# ping 192.168.56.20 -c 1