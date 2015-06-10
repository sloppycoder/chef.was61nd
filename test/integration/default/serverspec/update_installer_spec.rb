require "spec_helper"

updater_home = "/opt/IBM/WebSphere/UpdateInstaller"
updater_ver = '7.0.0.37'

describe file(updater_home) do
  it { should be_directory }
end

describe command("#{updater_home}/bin/versionInfo.sh") do
  its(:stdout) { should match /IBM Update Installer.*\n.*#{updater_ver}/ }
end

