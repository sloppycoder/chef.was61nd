default[:was61nd][:file_server_url] = 'http://some_server/'

default[:was61nd][:was_ver] = '6.1.0.0'
default[:was61nd][:was_installer] = "was_installer_#{default[:was61nd][:was_ver]}.tar.gz"
default[:was61nd][:was_install_location] = '/opt/IBM/WebSphere/AppServer'

default[:was61nd][:was_updater_ver] = '7.0.0.37'
default[:was61nd][:was_updater_installer] = "was_update_installer_#{default[:was61nd][:was_updater_ver]}.tar.gz"
default[:was61nd][:was_updater_parent_dir] = '/opt/IBM/WebSphere'

default[:was61nd][:was_fixpack_ver] = '47'
default[:was61nd][:was_fixpack_archive] = "was_fp#{default[:was61nd][:was_fixpack_ver]}.tar"
default[:was61nd][:was_updater_package_dir] = "#{default[:was61nd][:was_updater_parent_dir]}/UpdateInstaller/maintenance/"

default[:was61nd][:user] = 'wasadm'
default[:was61nd][:group] = 'wasuser'
