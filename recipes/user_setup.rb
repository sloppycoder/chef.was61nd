#
# Cookbook Name:: was61nd
# Recipe:: user_setup
#
#

include_recipe 'users'
include_recipe 'ulimit'

running_non_root = node['was61']['install_non_root']
was_user =  running_non_root ? node['was61']['user'] : 'root'
was_group = node['was61']['group']

users_manage was_user do
  action :create
  only_if { was_user != 'root' }
end

unless %w(root, wheel).include?(was_group)
  group was_group do
    action :create
    members [was_user]
  end

  user_ulimit "@#{was_group}" do
    filehandle_hard_limit 8192
    filehandle_soft_limit 8192
    process_soft_limit 131_072
    process_hard_limit 131_072
  end
end
