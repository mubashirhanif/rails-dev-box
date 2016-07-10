# -*- mode: ruby -*-
# vi: set ft=ruby :

unless Vagrant.has_plugin?("vagrant-hostmanager")
  raise 'vagrant-hostmanager is not installed!'
end

Vagrant.configure('2') do |config|
  config.vm.box      = 'ubuntu/trusty64'

  config.hostmanager.enabled = true
  config.hostmanager.manage_host = true
  config.hostmanager.manage_guest = true
  config.hostmanager.ignore_private_ip = false
  config.hostmanager.include_offline = true

  config.vm.hostname = 'test.biblionasium.com'
  config.vm.network :forwarded_port, guest: 3000, host: 80
  #config.vm.define :web do |web_config|
    #web_config.vm.hostname = "test.biblionasium.com"
    #web_config.vm.forward_port 80, 3000
  #end

  config.vm.provision :shell, path: 'bootstrap.sh', keep_color: true

  config.vm.provider 'virtualbox' do |v|
    v.memory = 2048
    v.cpus = 2
  end
end
