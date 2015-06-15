# there are some long lines so be it
# rubocop:disable Metrics/LineLength

default[:was61][:file_server_url] = 'http://some_server/'
default[:was61][:install_non_root] = false

default[:was61][:was_ver] = '6.1.0.0'
default[:was61][:was_installer] = "was_installer_#{default[:was61][:was_ver]}.tar.gz"
default[:was61][:was_install_location] = '/opt/IBM/WebSphere/AppServer'

default[:was61][:updater_ver] = '7.0.0.37'
default[:was61][:updater_installer] = "was_update_installer_#{default[:was61][:updater_ver]}.tar.gz"
default[:was61][:updater_home] = '/opt/IBM/WebSphere/UpdateInstaller'

default[:was61][:fixpack_ver] = '47'
default[:was61][:fixpack_tar] = "was_fp#{default[:was61][:fixpack_ver]}.tar"
default[:was61][:updater_package_dir] = "#{default[:was61][:updater_home]}/maintenance/"
default[:was61][:fixpack_product_location] = '/opt/IBM/WebSphere/AppServer'

default[:was61][:user] = 'wasadm'
default[:was61][:group] = 'wasuser'

# rubocop:enable Metrics/LineLength
