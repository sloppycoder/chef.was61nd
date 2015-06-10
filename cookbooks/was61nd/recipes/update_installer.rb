#
# Cookbook Name:: was61nd
# Recipe:: update_installer
#
#
CACHE = Chef::Config[:file_cache_path]


unless ::File.exists?(node[:was_updater_parent_dir])

  unpack_dir = ::File.join(CACHE, "update_installer")

  directory unpack_dir do
    action :create
  end

  installer = node[:file_server_url] + node[:was_updater_installer]
  if installer.start_with?("file://")
  	installer = installer.sub(/^file:\/\//, "")
  else 
	remote_file installer do
	  action :create_if_missing
	  mode 0644
	end
  end 

  execute "untar #{installer}" do
    command "tar zxf #{installer} -C #{unpack_dir}"
  end

  response_file = ::File.join(CACHE, "responsefile_updater.txt")
  template response_file do
    source "updater_responsefile.erb"
    variables({
      :install_parent_dir => node[:was_updater_parent_dir]
    })
  end

  execute "install update installer" do
    cwd unpack_dir + "/UpdateInstaller"
    user "root"
    umask 0022
    command "./install -options #{response_file}  -silent "
  end
end
