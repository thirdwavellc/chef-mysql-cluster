require 'spec_helper'

describe 'mysql-cluster-test::bootstrapping_first' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(step_into: ['mysql_cluster']).converge(described_recipe)
  end

  before do
    stub_command("mysqladmin --user=root --password='' version").and_return(true)
  end

  it 'should set the wsrep cluster address' do
    wsrep_cluster_address = chef_run.node['percona']['cluster']['wsrep_cluster_address']
    expect(wsrep_cluster_address).to eq('gcomm://')
  end
end

describe 'mysql-cluster-test::bootstrapping_last' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(step_into: ['mysql_cluster']).converge(described_recipe)
  end

  before do
    stub_command("mysqladmin --user=root --password='' version").and_return(true)
  end

  it 'should set the wsrep cluster address' do
    wsrep_cluster_address = chef_run.node['percona']['cluster']['wsrep_cluster_address']
    expect(wsrep_cluster_address).to eq('gcomm://192.168.10.1,192.168.10.2')
  end
end
