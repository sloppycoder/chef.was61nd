#
# Cookbook Name:: was61nd
# Recipe:: default
#
#
CACHE = Chef::Config[:file_cache_path]

was_home = node[:was_install_location]

unless ::File.exists? was_home

  # install the rpm packages required to IBM JRE
  if platform?("redhat", "centos") 
  	package ["compat-db", "compat-libstdc++-33"] do
  	  arch "i686"
  	  action :install
  	end
  end

  unpack_dir = ::File.join(CACHE, "was_installer")

  directory unpack_dir do
    action :create
  end

  installer = node[:file_server_url] + node[:was_installer]
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

  response_file = ::File.join(CACHE, "responsefile_was61nd.txt")
  template response_file do
    source "installer_responsefile.erb"
    variables({
      :install_location => node[:was_install_location]
    })
  end

  execute "install was" do
    cwd unpack_dir + "/WAS"
    user "root"
    umask 0022
    command "./install -options #{response_file}  -silent "
  end
end
