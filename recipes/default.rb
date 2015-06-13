#
# Cookbook Name:: was61nd
# Recipe:: default
#
#
include_recipe 'was61nd::user_setup'
include_recipe 'was61nd::base'
include_recipe 'was61nd::update_installer'
include_recipe 'was61nd::fixpack'
