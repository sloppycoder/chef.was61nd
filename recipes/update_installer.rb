#
# Cookbook Name:: was61nd
# Recipe:: update_installer
#
#
CACHE = Chef::Config['file_cache_path']

attribs = node['was61']

updater_home = attribs['updater_home']
was_user = attribs['install_non_root'] ? attribs['user'] : 'root'

unless ::File.exist?(updater_home)

  unpack_dir = ::File.join(CACHE, 'update_installer')

  directory unpack_dir do
    action :create
  end

  installer = CACHE + '/' + attribs['updater_installer']
  if installer.start_with?('file://')
    installer = installer.sub(%r{^file://}, '')
  else
    remote_file installer do
      action :create_if_missing
      mode 0644
      source attribs['file_server_url'] + attribs['updater_installer']
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
      install_location: updater_home,
      allow_non_root: was_user == 'root' ? 'false' : 'true'
    )
  end

  directory updater_home do
    owner attribs['user']
    group attribs['user']
    mode '0755'
    action :create
    recursive true
    only_if { was_user != 'root' }
  end

  execute 'install update installer' do
    cwd unpack_dir + '/UpdateInstaller'
    user was_user
    umask 0022
    command "./install -options #{response_file}  -silent "
  end

end
