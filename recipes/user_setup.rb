#
# Cookbook Name:: was61nd
# Recipe:: user_setup
#
#

include_recipe 'users'
include_recipe 'ulimit'

users_manage node[:user] do
  action :create
end

user_ulimit "@#{node[:user]}" do
  filehandle_hard_limit 8192
  filehandle_soft_limit 8192
  process_soft_limit 131_072
  process_hard_limit 131_072
end
