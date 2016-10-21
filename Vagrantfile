

# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.

Vagrant.configure(2) do |config|

  config.vm.box = "ubuntu/trusty64"
  config.ssh.insert_key = false

  if Vagrant.has_plugin?("vagrant-proxyconf")
    config.proxy.http     = "http://http-proxy:8080/"
    config.proxy.https    = "http://http-proxy:8080/"
    config.proxy.no_proxy = "localhost,127.0.0.1,192.168.56.20"
  end

  # pbm may orrur using private network  with virtual box 5.0 under Windows 7
  # http://stackoverflow.com/questions/33725779/failed-to-open-create-the-internal-network-vagrant-on-windows10
  config.vm.network :private_network, ip: "192.168.56.20"
  config.vm.network :private_network, ip: "192.168.57.20"

  config.vm.provider "virtualbox" do |v|
    v.name = "click_vm_for_test"
    v.customize ["modifyvm", :id, "--memory", "1024"]
    v.customize ["modifyvm", :id, "--nictype1", "virtio"]
    v.customize ["modifyvm", :id, "--nictype2", "virtio"]
    v.customize ["modifyvm", :id, "--nicpromisc2", "allow-all"]
    v.customize ["modifyvm", :id, "--nictype3", "virtio"]
    v.customize ["modifyvm", :id, "--nicpromisc3", "allow-all"]
  end

end