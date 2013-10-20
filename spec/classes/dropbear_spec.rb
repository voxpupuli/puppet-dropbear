require 'spec_helper'

describe 'dropbear', :type => :class do

  describe 'On an unknown operating system' do
    let(:facts) {{ :osfamily => 'Unknown' }}
    it "should fail" do
      expect do
        subject
      end.to raise_error(Puppet::Error, /Unsupported osfamily/)
    end
  end

  describe "On Debian" do
    let(:facts) {{ :osfamily => 'Debian' }}
    it { should include_class("dropbear::params") }
    it { should contain_package('dropbear') }
    it { should contain_service('dropbear') }
    it { should contain_file('/etc/default/dropbear/').with(
        :owner => 'root',
        :group => 'root',
        :mode  => '0444'
      )
    }
    context "When an alternate port is given" do
      let(:params) {{ :port => '42' }}
      it { should contain_file('/etc/default/dropbear/').with_content(/DROPBEAR_PORT=42/) }
    end
    context "When a banner is specified" do
      let(:params) {{ :banner => '/etc/test_banner' }}
      it { should contain_file('/etc/default/dropbear/').with_content(/DROPBEAR_BANNER="\/etc\/test_banner"/) }
    end
  end

  describe "On RedHat" do
    let(:facts) {{ :osfamily => 'RedHat' }}
    it { should include_class("dropbear::params") }
    it { should contain_package('dropbear') }
    it { should contain_service('dropbear') }
    it { should contain_file('/etc/sysconfig/dropbear/').with(
        :owner => 'root',
        :group => 'root',
        :mode  => '0444'
      )
    }
    context "When an alternate port is given" do
      let(:params) {{ :port => '42' }}
      it { should contain_file('/etc/sysconfig/dropbear/').with_content(/-p 42/) }
    end
    context "When a banner is specified" do
      let(:params) {{ :banner => '/etc/test_banner' }}
      it { should contain_file('/etc/sysconfig/dropbear/').with_content(/ -b \/etc\/test_banner /) }
    end
    context "When a banner is NOT specified" do
      it { should_not contain_file('/etc/sysconfig/dropbear/').with_content(/ -b /) }
    end
  end
end

