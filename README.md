# mysql-cluster

Installs and configures a MySQL mult-master cluster using Percona XtraDB
Cluster. Currently implemented as a wrapper of the [percona
cookbook](https://github.com/phlipper/chef-percona), provided as a simplified
LWRP.

## LWRPs

This cookbook is intended to be consumed through its LWRP, and therefore
doesn't include any recipes. Here is an overview of the LWRP provided:

### mysql_cluster

**Attributes**

| Name                      | Description                                      | Type    | Required | Default |
| ------------------------- | ------------------------------------------------ | ------- | -------- | ------- |
| cluster_name              | Name of the db cluster                           | String  | true     | N/A     |
| node_ips                  | Array of db nodes that make up the cluster       | Array   | true     | N/A     |
| bind_address              | Address to bind db to.                           | String  | true     | N/A     |
| bind_interface            | Interface to bind the db server to               | String  | true     | N/A     |
| root_password             | Root password for the db                         | String  | true     | N/A     |
| debian_password           | Debian password for the db                       | String  | true     | N/A     |
| bootstrapping             | Whether or not to treat the run as bootstrapping | Boolean | false    | false   |
| enable_myisam_replication | Whether or not to replicate MyISAM tables        | Boolean | false    | true    |

**Example:**

```ruby
mysql_cluster 'cluster01' do
  node_ips ['192.168.10.1', '192.168.10.2', '192.168.10.3']
  bind_address '192.168.10.1'
  bind_interface 'eth0'
  root_password 'mysecurepass'
  debian_password 'mysecurepass'
  bootstrapping true
end
```

**Note on Bootstrapping:** in order to make bootstrapping easy, we have
included a bootstrapping attribute. This affects the node_ips that are used in
the cluster address. By default, all node ips are included. If you are
bootstrapping, however, the first node will fail to startup because the other
nodes aren't running. Normally you would use the bootstrap-pxc option to
startup the db service (instead of `start`):

```shell
$ sudo service mysql bootstrap-pxc
```

You can do this manually and always keep the bootstrapping attribute to false,
or you can set it to true and it will use a cluster address that only includes
the previous nodes in the cluster:

	db01 -> gcomm://
	db02 -> gcomm://db01
	db03 -> gcomm://db01,db02

As long as you converge the nodes in the order of the `node_ips`, it should
bootstrap successfully. Once you have the whole cluster configured, you will
want to run Chef again on all nodes with `bootstrapping` set to false. This
will restore the default behavior, and all nodes will have a full cluster
address with all node ips. If you don't do this, you risk nodes failing to
rejoin the cluster when they restart (mainly the first node, which has an empty
cluster address).
