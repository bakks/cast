require 'spec_helper'

describe Cast do
  it 'should load groups' do
    groups = Cast::load_groups 'spec/test.yml'
    groups.size.should == 2
    groups['group1'].size.should == 3
    groups['group1'][0].should == 'host1'
  end

  it 'should expand groups' do
    groups = Cast::load_groups 'spec/test.yml'
    hosts = Cast::expand_groups ['group1'], groups
    hosts.size.should == 3
    hosts[0].should == 'host1'
    hosts[1].should == 'host2'
    hosts[2].should == 'host3'

    hosts = Cast::expand_groups ['group1', 'group2']
    hosts.size.should == 5
    hosts[0].should == 'host1'
    hosts[1].should == 'host2'
    hosts[2].should == 'host3'
    hosts[3].should == 'host4'
    hosts[4].should == 'host5'

    hosts = Cast::expand_groups ['host10', 'group1', 'host11', 'group2']
    hosts.size.should == 7
    hosts[0].should == 'host10'
    hosts[1].should == 'host1'
    hosts[2].should == 'host2'
    hosts[3].should == 'host3'
    hosts[4].should == 'host11'
    hosts[5].should == 'host4'
    hosts[6].should == 'host5'
  end
end

