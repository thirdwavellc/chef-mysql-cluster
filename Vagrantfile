# -*- mode: ruby -*-
# vi: set ft=ruby :

NUMBER_DBS = 3

Vagrant.configure(2) do |config|
  config.vm.box = 'chef/ubuntu-14.04'

  1.upto(NUMBER_DBS).each do |num|
    name = "db0#{num}"
    config.vm.define name do |db|
      db.vm.hostname = name
      db.vm.network 'private_network', ip: "172.20.30.#{9+num}"

      db.vm.provider 'virtualbox' do |vb|
        vb.memory = 2048
        vb.cpus = 2
      end

      db.vm.provision 'chef_solo' do |chef|
        chef.add_recipe 'mysql-cluster::default'
      end
    end
  end
end
