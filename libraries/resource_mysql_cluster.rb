#
# Cookbook Name:: mysql-cluster
# Resource:: mysql_cluster
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

require 'chef/resource/lwrp_base'

class Chef
  class Resource
    class MysqlCluster < Chef::Resource::LWRPBase
      self.resource_name = :mysql_cluster
      actions :create
      default_action :create

      attribute :cluster_name, kind_of: String, name_attribute: true
      attribute :node_ips, kind_of: Array, required: true
      attribute :bind_address, kind_of: String, required: true
      attribute :bind_interface, kind_of: String, required: true
      attribute :root_password, kind_of: String, required: true
      attribute :debian_password, kind_of: String, required: true
      attribute :bootstrapping, equal_to: [true, false], default: false
      attribute :enable_myisam_replication, equal_to: [true, false], default: true

      def cluster_ips
        return node_ips unless bootstrapping
        ips = []

        node_ips.each do |ip|
          break if ip == bind_address
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
