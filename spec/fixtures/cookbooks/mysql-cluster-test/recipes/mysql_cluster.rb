#
# Cookbook Name:: mysql-cluster-test
# Recipe:: mysql_cluster
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

mysql_cluster 'cluster01' do
  node_ips ['192.168.10.1', '192.168.10.2', '192.168.10.3']
  bind_address '192.168.10.1'
  bind_interface 'eth0'
  root_password 'mysecurepass'
  debian_password 'mysecurepass'
  bootstrapping false
end
