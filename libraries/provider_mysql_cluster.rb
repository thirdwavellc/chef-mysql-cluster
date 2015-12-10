#
# Cookbook Name:: mysql-cluster
# Provider:: mysql_cluster
#
# Copyright 2014 Adam Krone <adam.krone@thirdwavellc.com>
# Copyright 2014 Thirdwave, LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require 'chef/provider/lwrp_base'

class Chef
  class Provider
    class MysqlCluster < Chef::Provider::LWRPBase
      include Chef::DSL::IncludeRecipe
      use_inline_resources if defined?(use_inline_resources)

      def whyrun_supported?
        true
      end

      action :create do
        include_recipe 'apt'

        node.normal['percona']['version'] = '5.6'
        node.normal['percona']['server']['role'] = 'cluster'
        node.normal['percona']['server']['root_password'] = new_resource.root_password
        node.normal['percona']['server']['debian_password'] = new_resource.debian_password
        node.normal['percona']['server']['bind_address'] = new_resource.bind_address
        node.normal['percona']['cluster']['wsrep_cluster_name'] = new_resource.cluster_name
        node.normal['percona']['cluster']['wsrep_sst_receive_interface'] =
          new_resource.bind_interface

        Chef::Log.info "Using Percona XtraDB cluster address of: #{new_resource.cluster_address}"
        node.override['percona']['cluster']['wsrep_cluster_address'] = new_resource.cluster_address
        node.override['percona']['cluster']['wsrep_node_name'] = node['hostname']
        node.normal['percona']['cluster']['package'] = 'percona-xtradb-cluster-56'

        include_recipe 'percona::cluster'
        include_recipe 'percona::backup'
        include_recipe 'percona::toolkit'

        if new_resource.enable_myisam_replication
          template '/etc/mysql/conf.d/wsrep_replicate_myisam.cnf' do
            cookbook 'mysql-cluster'
            source 'wsrep_replicate_myisam.cnf.erb'
            action :create_if_missing
            notifies :restart, 'service[mysql]', :delayed
          end
        end
      end
    end
  end
end
