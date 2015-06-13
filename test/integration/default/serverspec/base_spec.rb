require 'spec_helper'

# test kitchen does not support using Chef attribute in tests
# so the below are redundant of attributes of recipes.
was_home = '/opt/IBM/WebSphere/AppServer'
was_ver = '6.1'
was_user = 'wasadm'

if %w(redhat, centos).include?(os[:family])
  describe package('compat-db') do
    it { should be_installed }
  end

  describe package('compat-libstdc++-33') do
    it { should be_installed }
  end
end

describe file(was_home) do
  it { should be_directory }
  it { should be_mode 755 }
  it { should be_owned_by was_user }
end

describe command("#{was_home}/java/bin/java -version") do
  its(:stdout) { should match(/IBM J9 VM/) }
end

describe command("#{was_home}/bin/versionInfo.sh") do
  its(:stdout) { should match(/WebSphere Application Server.*\n.*#{was_ver}/) }
end
