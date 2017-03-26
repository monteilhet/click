

printf "\nClick User-level test\n"
printf "=======================\n"
click /vagrant/samples/usermode/test.click

echo
echo "run click user mode config to block network traffic on eth1"
echo "try ping 192.168.56.20 -c 1 (expect no ping response)"

sudo click /vagrant/samples/usermode/test-device-block.click


# another user config to handle a new IP 192.168.56.60 managed only in click config
# sudo click /vagrant/samples/usermode/test-arp-ping.click
# arping -I vboxnet0 192.168.56.60 -c 1
# ping 192.168.56.60 -c 1

# user config showing packet classifiction
# sudo click /vagrant/samples/usermode/test-classify.click


printf "\nClick kernel test\n"
printf "===================\n"

echo
echo "run click kernel mode config to block network traffic on eth1"
echo "NB run: click-uninstall -V to uninstall click config"

sudo click-install -V /vagrant/samples/kernelmode/test-device-block.click
sudo tail -f /var/log/syslog

# test ping will not reply
# ping 192.168.56.20 -c 1


