require 'spec_helper'

# test kitchen does not support using Chef attribute in tests
# so the below are redundant of attributes of recipes.
profile_home = '/opt/IBM/WebSphere/AppServer/profiles/AppSrv01'
profile_port = 9060
profile_owner = 'team1'
was_group = 'tstgrp'

describe user(profile_owner) do
  it { should exist }
  it { should belong_to_group was_group }
end

describe file(profile_home) do
  it { should be_directory }
  it { should be_owned_by profile_owner }
end

describe command("sudo su #{profile_owner} -c\
                    'cd #{profile_home}/bin ; ./startServer.sh server1'") do
  its(:stdout) { should match(/open for e-business/) }
end

describe port(profile_port) do
  it { should be_listening }
end

# ivt is a default web app that is installed when the profile is created
describe command("curl http://127.0.0.1:#{profile_port}/ivt/ivtDate.jsp") do
  its(:stdout) { should match(/IVT JSP/) }
end
