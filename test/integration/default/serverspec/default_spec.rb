require "spec_helper"

# test kitchen does not support using Chef attribute in tests
was_home ="/opt/IBM/WebSphere/AppServer"

describe package("compat-db"), ["redhat", "centos"].include?(os[:family]) do
  it { should be_installed }
end

describe package("compat-libstdc++-33"), ["redhat", "centos"].include?(os[:family]) do
  it { should be_installed }
end

describe file(was_home) do
  it { should be_directory }
end

describe command("#{was_home}/java/bin/java -version") do
  its(:stdout) { should match /IBM J9 VM/ }
end

describe command("#{was_home}/bin/versionInfo.sh") do
  its(:stdout) { should match /IBM WebSphere Application Server.*\n.*6.1.0.0/ }
end

