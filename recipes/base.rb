#
# Cookbook Name:: was61nd
# Recipe:: base
#
#
CACHE = Chef::Config[:file_cache_path]

attribs = node[:was61nd]

was_home = attribs[:was_install_location]

unless ::File.exist? was_home

  # install the rpm packages required to IBM JRE
  if platform?('redhat', 'centos')
    package ['compat-db', 'compat-libstdc++-33'] do
      arch 'i686'
      action :install
    end
  end

  unpack_dir = ::File.join(CACHE, 'was_installer')

  directory unpack_dir do
    action :create
  end

  installer =  CACHE + '/' + attribs[:was_installer]
  if installer.start_with?('file://')
    installer = installer.sub(%r{^file://}, '')
  else
    remote_file installer do
      action :create_if_missing
      mode 0644
      source attribs[:file_server_url] + attribs[:was_installer]
    end
  end

  execute "untar #{installer}" do
    umask 0022
    command "tar zxf #{installer} -C #{unpack_dir}"
  end

  response_file = ::File.join(CACHE, 'responsefile_was61nd.txt')
  template response_file do
    source 'installer_responsefile.erb'
    variables(
      install_location: was_home
    )
  end

  directory "#{was_home}" do
    owner attribs[:user]
    group attribs[:user]
    mode '0755'
    action :create
    recursive true
  end

  execute 'install was' do
    cwd unpack_dir + '/WAS'
    user attribs[:user]
    umask 0022
    command "./install -options #{response_file}  -silent "
  end
end
