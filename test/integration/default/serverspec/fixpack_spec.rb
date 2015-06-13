require 'spec_helper'

# test kitchen does not support using Chef attribute in tests
# so the below are redundant of attributes of recipes.
was_home = '/opt/IBM/WebSphere/AppServer'
was_ver = '6.1.0.47'
java_ver = 'SR16 FP3'

describe command("#{was_home}/java/bin/java -version") do
  its(:stdout) { should match(/#{java_ver}/) }
end

describe command("#{was_home}/bin/versionInfo.sh") do
  its(:stdout) { should match(/WebSphere Application Server.*\n.*#{was_ver}/) }
end
