#
# Cookbook Name:: was61nd
# Recipe:: create_profile
#
#
CACHE = Chef::Config[:file_cache_path]

was_home = node[:was_install_location]
was_user = node[:user]
was_group = node[:group]

profile_name = node[:profile_name] || 'AppSrv01'
profile_path = node[:profile_path] || "#{was_home}/profiles/#{profile_name}"
profile_type = node[:profile_type] || 'default'
profile_start_port = node[:starting_port] || 9060
profile_owner = node[:profile_owner]

execute "create new profile #{profile_name}" do
  user was_user
  umask 0022
  cwd "#{was_home}/bin"
  command %( \
./manageprofiles.sh \
 -create \
 -profileName #{profile_name} \
 -profilePath #{profile_path} \
 -templatePath #{was_home}/profileTemplates/#{profile_type} \
 -startingPort #{profile_start_port})
end

if profile_owner && profile_owner != was_user

  users_manage profile_owner do
    action :create
  end

  group was_group do
    action :modify
    append true
    members [profile_owner]
  end

  cmd = "chown -R #{profile_owner}:#{profile_owner} #{profile_path}"
  execute cmd do
    command cmd
    user 'root'
    action :run
  end
end
