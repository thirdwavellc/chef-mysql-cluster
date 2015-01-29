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

        node.normal['percona']['server']['role'] = 'cluster'
        node.normal['percona']['server']['root_password'] = new_resource.root_password
        node.normal['percona']['server']['debian_password'] = new_resource.debian_password
        node.normal['percona']['server']['bind_address'] = new_resource.node_ip
        node.normal['percona']['cluster']['wsrep_cluster_name'] = new_resource.cluster_name
        node.normal['percona']['cluster']['wsrep_sst_receive_interface'] = new_resource.bind_interface

        Chef::Log.info "Using Percona XtraDB cluster address of: #{new_resource.cluster_address}"
        node.override['percona']['cluster']['wsrep_cluster_address'] = new_resource.cluster_address
        node.override['percona']['cluster']['wsrep_node_name'] = node['hostname']

        include_recipe 'percona::cluster'
        include_recipe 'percona::backup'
        include_recipe 'percona::toolkit'
      end
    end
  end
end
