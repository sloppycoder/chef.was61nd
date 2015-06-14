#
# Cookbook Name:: was61nd
# Recipe:: fixpack
#
#
CACHE = Chef::Config[:file_cache_path]

attribs = node[:was61nd]

was_home = attribs[:was_install_location]
pak_dir = attribs[:was_updater_package_dir]

installer = CACHE + '/' + attribs[:was_fixpack_archive]
if installer.start_with?('file://')
  installer = installer.sub(%r{^file://}, '')
else
  remote_file installer do
    action :create_if_missing
    mode 0644
    source attribs[:file_server_url] + attribs[:was_fixpack_archive]
  end
end

execute "untar #{installer}" do
  user attribs[:user]
  umask 0022
  command "[ -d #{pak_dir} ] " # will return exit code 1 if dir does not exist
  command "rm -f #{pak_dir}/*.pak"
  command "tar xf #{installer} -C #{pak_dir}"
end

response_file = ::File.join(CACHE, 'responsefile_fixpack.txt')
template response_file do
  source 'fixpack_install_responsefile.erb'
  variables(
    install_location: was_home
  )
end

execute 'install fixpacks' do
  cwd attribs[:was_updater_package_dir] + '/..'
  user attribs[:user]
  umask 0022
  command "./update.sh -silent -options #{response_file}"
end
