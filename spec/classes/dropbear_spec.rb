require 'spec_helper'

describe 'dropbear', :type => :class do

  describe 'On an unknown operating system' do
    let(:facts) {{ :osfamily => 'Unknown' }}
    it "is_expected.to fail" do
      expect do
        subject
      end.to raise_error(Puppet::Error, /Unsupported osfamily/)
    end
  end

  describe "On Debian" do
    let(:facts) {{ :osfamily => 'Debian' }}
    it { is_expected.to contain_class("dropbear::params") }
    it { is_expected.to contain_package('dropbear') }
    it { is_expected.to contain_service('dropbear') }
    it { is_expected.to contain_file('/etc/default/dropbear/').with(
        :owner => 'root',
        :group => 'root',
        :mode  => '0444'
      )
    }
    context "When an alternate port is given" do
      let(:params) {{ :port => '42' }}
      it { is_expected.to contain_file('/etc/default/dropbear/').with_content(/DROPBEAR_PORT=42/) }
    end
    context "When a banner is specified" do
      let(:params) {{ :banner => '/etc/test_banner' }}
      it { is_expected.to contain_file('/etc/default/dropbear/').with_content(/DROPBEAR_BANNER="\/etc\/test_banner"/) }
    end
  end

  describe "On RedHat" do
    let(:facts) {{ :osfamily => 'RedHat' }}
    it { is_expected.to contain_class("dropbear::params") }
    it { is_expected.to contain_package('dropbear') }
    it { is_expected.to contain_service('dropbear') }
    it { is_expected.to contain_file('/etc/sysconfig/dropbear/').with(
        :owner => 'root',
        :group => 'root',
        :mode  => '0444'
      )
    }
    context "When an alternate port is given" do
      let(:params) {{ :port => '42' }}
      it { is_expected.to contain_file('/etc/sysconfig/dropbear/').with_content(/-p 42/) }
    end
    context "When a banner is specified" do
      let(:params) {{ :banner => '/etc/test_banner' }}
      it { is_expected.to contain_file('/etc/sysconfig/dropbear/').with_content(/ -b \/etc\/test_banner /) }
    end
    context "When a banner is NOT specified" do
      it { is_expected.to_not contain_file('/etc/sysconfig/dropbear/').with_content(/ -b /) }
    end
  end
end

