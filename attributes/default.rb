default[:was61nd][:file_server_url] = 'http://some_server/'

default[:was61nd][:was_ver] = '6.1.0.0'
default[:was61nd][:was_installer] = "was_installer_#{default[:was61nd][:was_ver]}.tar.gz"
default[:was61nd][:was_install_location] = '/opt/IBM/WebSphere/AppServer'

default[:was61nd][:updater_ver] = '7.0.0.37'
default[:was61nd][:updater_installer] = "was_update_installer_#{default[:was61nd][:updater_ver]}.tar.gz"
default[:was61nd][:updater_home] = '/opt/IBM/WebSphere/UpdateInstaller'
default[:was61nd][:updater_non_root] = 'true'

default[:was61nd][:fixpack_ver] = '47'
default[:was61nd][:fixpack_tar] = "was_fp#{default[:was61nd][:fixpack_ver]}.tar"
default[:was61nd][:updater_package_dir] = "#{default[:was61nd][:updater_home]}/maintenance/"
default[:was61nd][:fixpack_product_location] = '/opt/IBM/WebSphere/AppServer'

default[:was61nd][:user] = 'wasadm'
default[:was61nd][:group] = 'wasuser'
