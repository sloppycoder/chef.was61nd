default[:file_server_url] = 'http://file_server/some_stupid_directory/ibm/was61nd/linux/x32/'
default[:was_ver] = '6.1.0.0'
default[:was_installer] = "was_installer_#{default[:was_ver]}.tar.gz"
default[:was_install_location] = '/opt/IBM/WebSphere/AppServer'

default[:was_updater_ver] = '7.0.0.37'
default[:was_updater_installer] = "was_update_installer_#{default[:was_updater_ver]}.tar.gz"
default[:was_updater_parent_dir] = '/opt/IBM/WebSphere'

default[:was_fixpack_ver] = '47'
default[:was_fixpack_archive] = "was_fp#{default[:was_fixpack_ver]}.tar"
default[:was_updater_package_dir] = "#{default[:was_updater_parent_dir]}/UpdateInstaller/maintenance/"

default[:user] = 'wasadm'


