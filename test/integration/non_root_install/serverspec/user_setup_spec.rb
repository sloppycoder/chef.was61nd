require 'spec_helper'

# test kitchen does not support using Chef attribute in tests
# so the below are redundant of attributes of recipes.
was_user = 'tst1'
was_group = 'tstgrp'
nfile = 8192
nproc = 131_072

describe user(was_user) do
  it { should exist }
  it { should belong_to_group was_group }
end

describe command("sudo su #{was_user} -c 'ulimit -n' ") do
  its(:stdout) { should match(/#{nfile}/) }
end

describe command("sudo su #{was_user} -c 'ulimit -u' ") do
  its(:stdout) { should match(/#{nproc}/) }
end
