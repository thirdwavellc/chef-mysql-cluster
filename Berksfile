source 'https://supermarket.getchef.com'

metadata

cookbook 'apt'
cookbook 'percona', github: 'phlipper/chef-percona'

group :test do
  cookbook 'mysql-cluster-test', path: 'spec/fixtures/cookbooks/mysql-cluster-test'
end
