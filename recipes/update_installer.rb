#
# Cookbook Name:: was61nd
# Recipe:: update_installer
#
#
CACHE = Chef::Config[:file_cache_path]

parent_dir = node[:was_updater_parent_dir]

unless ::File.exist?("#{parent_dir}/UpdateInstaller")

  unpack_dir = ::File.join(CACHE, 'update_installer')

  directory unpack_dir do
    action :create
  end

  installer = node[:file_server_url] + node[:was_updater_installer]
  if installer.start_with?('file://')
    installer = installer.sub(%r{^file://}, '')
  else
    remote_file installer do
      action :create_if_missing
      mode 0644
    end
  end

  execute "untar #{installer}" do
    umask 0022
    command "tar zxf #{installer} -C #{unpack_dir}"
  end

  response_file = ::File.join(CACHE, 'responsefile_updater.txt')
  template response_file do
    source 'updater_responsefile.erb'
    variables(
      install_parent_dir: parent_dir
    )
  end

  directory "#{parent_dir}/UpdateInstaller" do
    owner node[:user]
    group node[:user]
    mode '0755'
    action :create
    recursive true
  end

  execute 'install update installer' do
    cwd unpack_dir + '/UpdateInstaller'
    user node[:user]
    umask 0022
    command "./install -options #{response_file}  -silent "
  end

end
