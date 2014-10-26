require 'spec_helper'

describe Cast do
  it 'should return the command output' do
    r = Cast::local 'true'
    expect(r).to eq(0)

    r = Cast::local 'false'
    expect(r).to eq(1)
  end

  it 'should ensure local commands finish' do
    r = Cast::local 'true', {:ensure => true}
    expect(r).to eq(0)
    expect { Cast::local('false', {:ensure => true}) }.to raise_error
  end

  it 'should load groups' do
    groups = Cast::load_groups 'spec/test.yml'
    expect(groups.size).to eq(2)
    expect(groups['group1'].size).to eq(3)
    expect(groups['group1'][0]).to eq('host1')
  end

  it 'should expand groups' do
    groups = Cast::load_groups 'spec/test.yml'
    hosts = Cast::expand_groups ['group1'], groups
    expect(hosts.size).to eq(3)
    expect(hosts[0]).to eq('host1')
    expect(hosts[1]).to eq('host2')
    expect(hosts[2]).to eq('host3')

    hosts = Cast::expand_groups ['group1', 'group2']
    expect(hosts.size).to eq(5)
    expect(hosts[0]).to eq('host1')
    expect(hosts[1]).to eq('host2')
    expect(hosts[2]).to eq('host3')
    expect(hosts[3]).to eq('host4')
    expect(hosts[4]).to eq('host5')

    hosts = Cast::expand_groups ['host10', 'group1', 'host11', 'group2']
    expect(hosts.size).to eq(7)
    expect(hosts[0]).to eq('host10')
    expect(hosts[1]).to eq('host1')
    expect(hosts[2]).to eq('host2')
    expect(hosts[3]).to eq('host3')
    expect(hosts[4]).to eq('host11')
    expect(hosts[5]).to eq('host4')
    expect(hosts[6]).to eq('host5')
  end
end

