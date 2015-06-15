#
# Cookbook Name:: was61nd
# Recipe:: create_profile
#
#
CACHE = Chef::Config[:file_cache_path]

attribs = node[:was61]

was_home = attribs[:was_install_location]
was_user = attribs[:install_non_root] ? attribs[:user] : 'root'
was_group = attribs[:group]

profile_name = attribs[:profile_name] || 'AppSrv01'
profile_path = attribs[:profile_path] || "#{was_home}/profiles/#{profile_name}"
profile_type = attribs[:profile_type] || 'default'
profile_start_port = attribs[:starting_port] || 9060
profile_owner = attribs[:profile_owner]

execute 'check to see if hostname can be resolved' do
  command 'hostname | xargs ping -c 1'
end

unless ::File.exist? profile_path
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

  if was_user != 'root'
    cmd = "chown -R #{profile_owner}:#{profile_owner} #{profile_path}"
    execute cmd do
      command cmd
      user 'root'
      action :run
    end
  end
end
