require 'spec_helper'

describe 'mysql-cluster-test::mysql_cluster' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(step_into: ['mysql_cluster']).converge(described_recipe)
  end

  before do
    stub_command("mysqladmin --user=root --password='' version").and_return(true)
  end

  it 'should create mysql_cluster[cluster01]' do
    expect(chef_run).to create_mysql_cluster('cluster01')
  end

  it 'should set the percona version' do
    version = chef_run.node['percona']['version']
    expect(version).to eq('5.6')
  end

  it 'should set the percona server role to cluster' do
    server_role = chef_run.node['percona']['server']['role']
    expect(server_role).to eq('cluster')
  end

  it 'should set the percona server root password' do
    root_password = chef_run.node['percona']['server']['root_password']
    expect(root_password).to eq('mysecurepass')
  end

  it 'should set the percona server debian password' do
    debian_password = chef_run.node['percona']['server']['debian_password']
    expect(debian_password).to eq('mysecurepass')
  end

  it 'should set the percona server bind address' do
    bind_address = chef_run.node['percona']['server']['bind_address']
    expect(bind_address).to eq('192.168.10.1')
  end

  it 'should set the percona wsrep cluster name' do
    wsrep_cluster_name = chef_run.node['percona']['cluster']['wsrep_cluster_name']
    expect(wsrep_cluster_name).to eq('cluster01')
  end

  it 'should set the percona wsrep sst receive interface' do
    wsrep_sst_receive_interface = chef_run.node['percona']['cluster']['wsrep_sst_receive_interface']
    expect(wsrep_sst_receive_interface).to eq('eth0')
  end

  it 'should set the percona wsrep cluster address' do
    wsrep_cluster_address = chef_run.node['percona']['cluster']['wsrep_cluster_address']
    expect(wsrep_cluster_address).to eq('gcomm://192.168.10.1,192.168.10.2,192.168.10.3')
  end

  it 'should set the percona wsrep node name' do
    wsrep_node_name = chef_run.node['percona']['cluster']['wsrep_node_name']
    expect(wsrep_node_name).to eq('Fauxhai')
  end

  it 'should set the percona cluster package' do
    cluster_package = chef_run.node['percona']['cluster']['package']
    expect(cluster_package).to eq('percona-xtradb-cluster-56')
  end

  it 'should include the percona::cluster recipe' do
    expect(chef_run).to include_recipe('percona::cluster')
  end

  it 'should include the percona::backup recipe' do
    expect(chef_run).to include_recipe('percona::backup')
  end

  it 'should include the percona::toolkit recipe' do
    expect(chef_run).to include_recipe('percona::toolkit')
  end
end
