require 'spec_helper'

# test kitchen does not support using Chef attribute in tests
# so the below are redundant of attributes of recipes.
updater_home = '/opt/IBM/WebSphere/UpdateInstaller'
updater_ver = '7.0.0.37'
was_user = 'tst1'

describe file(updater_home) do
  it { should be_directory }
  it { should be_owned_by was_user }
end

describe command("#{updater_home}/bin/versionInfo.sh") do
  its(:stdout) { should match(/IBM Update Installer.*\n.*#{updater_ver}/) }
end
