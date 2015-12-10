def create_mysql_cluster(resource_name)
  ChefSpec::Matchers::ResourceMatcher.new(:mysql_cluster, :create, resource_name)
end
