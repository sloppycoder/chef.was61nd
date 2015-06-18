#
# Cookbook Name:: was61nd
# Recipe:: base
#
#
CACHE = Chef::Config['file_cache_path']

attribs = node['was61']

was_home = attribs['was_install_location']
was_user = attribs['install_non_root'] ? attribs['user'] : 'root'

unless ::File.exist? was_home

  # install the rpm packages required to IBM JRE
  package ['compat-db', 'compat-libstdc++-33'] do
    arch 'i686'
    action :install
    only_if { platform?('redhat', 'centos', 'amazon', 'scientific') }
  end

  unpack_dir = ::File.join(CACHE, 'was_installer')

  directory unpack_dir do
    action :create
  end

  installer =  CACHE + '/' + attribs['was_installer']
  if installer.start_with?('file://')
    installer = installer.sub(%r{^file://}, '')
  else
    remote_file installer do
      action :create_if_missing
      mode 0644
      source attribs['file_server_url'] + attribs['was_installer']
    end
  end

  execute "untar #{installer}" do
    umask 0022
    command "tar zxf #{installer} -C #{unpack_dir}"
  end

  response_file = ::File.join(CACHE, 'responsefile_installer.txt')
  template response_file do
    source 'installer_responsefile.erb'
    variables(
      install_location: was_home,
      allow_non_root: was_user == 'root' ? 'false' : 'true'
    )
  end

  directory was_home do
    owner attribs['user']
    group attribs['user']
    mode '0755'
    action :create
    recursive true
    only_if { was_user != 'root' }
  end

  execute 'install was' do
    cwd unpack_dir + '/WAS'
    user was_user
    umask 0022
    command "./install -options #{response_file}  -silent "
  end
end
