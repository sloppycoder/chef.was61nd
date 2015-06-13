#
# Cookbook Name:: was61nd
# Recipe:: user_setup
#
#

include_recipe 'users'
include_recipe 'ulimit'

was_user = node[:user]
was_group = node[:group]

users_manage was_user do
  action :create
end

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
