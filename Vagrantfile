

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

 config.vm.define :pc1 do |config|

  config.vm.hostname = "pc1"
  # pbm may orrur using private network  with virtual box 5.0 under Windows 7
  # http://stackoverflow.com/questions/33725779/failed-to-open-create-the-internal-network-vagrant-on-windows10
  config.vm.network :private_network, ip: "192.168.56.20"
  config.vm.network :private_network, ip: "192.168.57.20"

  config.vm.provider "virtualbox" do |v|
    v.name = "click_pc1_vm"
    v.customize ["modifyvm", :id, "--memory", "1024"]
    v.customize ["modifyvm", :id, "--nictype1", "virtio"]
    v.customize ["modifyvm", :id, "--nictype2", "virtio"]
    v.customize ["modifyvm", :id, "--nicpromisc2", "allow-all"]
    v.customize ["modifyvm", :id, "--nictype3", "virtio"]
    v.customize ["modifyvm", :id, "--nicpromisc3", "allow-all"]
  end
 end

 config.vm.define :pc2 do |config|

  config.vm.hostname = "pc2"

  # test to build click with kernel 4.4
  # config.vm.box = "ubuntu/xenial64"
  # config.ssh.insert_key = true

  # pbm may orrur using private network  with virtual box 5.0 under Windows 7
  # http://stackoverflow.com/questions/33725779/failed-to-open-create-the-internal-network-vagrant-on-windows10

  config.vm.network :private_network, ip: "192.168.56.21" #, auto_config: false
  config.vm.network :private_network, ip: "192.168.57.21" #, auto_config: false

  config.vm.provider "virtualbox" do |v|
    v.name = "click_pc2_vm"
    v.customize ["modifyvm", :id, "--memory", "1024"]
    v.customize ["modifyvm", :id, "--nictype1", "virtio"]
    v.customize ["modifyvm", :id, "--nictype2", "virtio"]
    v.customize ["modifyvm", :id, "--nicpromisc2", "allow-all"]
    v.customize ["modifyvm", :id, "--nictype3", "virtio"]
    v.customize ["modifyvm", :id, "--nicpromisc3", "allow-all"]
  end
 end

# vm to build click box
 config.vm.define :click_box do |config|
   no_proxy = true

  if Vagrant.has_plugin?("vagrant-proxyconf") && no_proxy
    config.proxy.http     = ""
    config.proxy.https    = ""
    config.proxy.no_proxy = ""
  end

  # "debian/jessie64"
  # "s12v/xenial64"
  $boxname = "debian/contrib-jessie64"
  config.vm.box = $boxname 
  # build click with kernel 4.4 and ubuntu with Predictable network interface names turned off
  #config.ssh.insert_key = true
  config.vm.hostname = "click"

  config.vm.provider "virtualbox" do |v|
    v.name = "click_vm"
    v.customize ["modifyvm", :id, "--memory", "1024"]
    v.customize ["modifyvm", :id, "--nictype1", "virtio"]
  end
 end



end