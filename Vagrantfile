# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  config.vm.box = "generic/ubuntu2004" 
  config.vm.provider "virtualbox"  
  #Configura el hostname de la máquina
  config.vm.hostname = "serMLLS"
  config.vm.network "forwarded_port", guest: 3306, host: 3306

  config.vm.network "private_network", ip: "192.168.250.254"

  config.vm.synced_folder ".", "/vagrant", disabled: false
  
  #Si el provider es virtualbox 
  config.vm.provider "virtualbox" do |vb|
    #vb.gui = true 
    vb.name = "UbuntuDWES"
    vb.memory = 2048
    vb.cpus = 2   
  end
  config.vm.provision "shell", path: "bootstrap.sh"
end