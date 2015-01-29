require 'chef/resource/lwrp_base'

class Chef
  class Resource
    class MysqlCluster < Chef::Resource::LWRPBase
      self.resource_name = :mysql_cluster
      actions :create
      default_action :create

      attribute :cluster_name, kind_of: String, name_attribute: true
      attribute :node_ips, kind_of: Array, required: true
      attribute :bind_interface, kind_of: String, required: true
      attribute :root_password, kind_of: String, required: true
      attribute :debian_password, kind_of: String, required: true

      def node_ip
        node['network']['interfaces']["#{bind_interface}"]['addresses']
          .detect{|k,v| v['family'] == 'inet'}
          .first
      end

      def cluster_ips
        ips = []

        node_ips.each do |ip|
          break if ip == node_ip
          ips << ip
        end

        ips
      end

      def cluster_address
        "gcomm://#{cluster_ips.join(',')}"
      end
    end
  end
end
