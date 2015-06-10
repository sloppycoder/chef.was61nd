#
# Cookbook Name:: was61nd
# Recipe:: fixpack
#
#
CACHE = Chef::Config[:file_cache_path]

was_home = node[:was_install_location]
pak_dir = node[:was_updater_package_dir]


installer = node[:file_server_url] + node[:was_fixpack_archive]
if installer.start_with?("file://")
	installer = installer.sub(/^file:\/\//, "")
else 
	remote_file installer do
	  action :create_if_missing
	  mode 0644
	end
end 

execute "untar #{installer}" do
  command "[ -d #{pak_dir} ] " # will return exit code 1 if dir does not exist
  command "rm -f #{pak_dir}/*.pak"
  command "tar xf #{installer} -C #{pak_dir}"
end

response_file = ::File.join(CACHE, "responsefile_fixpack.txt")
template response_file do
  source "fixpack_install_responsefile.erb"
  variables({
    :install_location => was_home
  })
end

execute "install fixpacks" do
  cwd  node[:was_updater_package_dir]+ "/.."
  user "root"
  umask 0022
  command "./update.sh -silent -options #{response_file}"
end

