require 'spec_helper'

describe 'dropbear' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        unless facts['os'].is_a?(Hash)
          facts['os'] = {}
        end

        case os
        when /(ubuntu-\d+.\d+|debian-\d+)-x86_64/
          facts['os']['family'] = 'Debian'
        when /freebsd-\d+-amd64/
          facts['os']['family'] = 'FreeBSD'
        when /(redhat|centos|fedora)-\d+-x86_64/
          facts['os']['family'] = 'RedHat'
        end
        facts
      end

      conf_file = facts[:osfamily] == 'RedHat' ? '/etc/sysconfig/dropbear' : '/etc/default/dropbear'

      context 'with all defaults' do
        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_class('dropbear') }
        it { is_expected.to contain_package('dropbear') }
        it { is_expected.to contain_service('dropbear') }
        it {
          is_expected.to contain_file(conf_file).with(
            'owner' => 'root',
            'group' => 'root',
            'mode'  => '0444'
          )
        }
      end

      context 'When an alternate port is given' do
        let(:params) { { port: '42' } }

        it { is_expected.to contain_file(conf_file).with_content(%r{42}) }
      end
      context 'When a banner is specified' do
        let(:params) { { banner: '/etc/test_banner' } }

        it { is_expected.to contain_file(conf_file).with_content(%r{/etc/test_banner}) }
      end
      context 'When a banner is NOT specified' do
        it { is_expected.not_to contain_file(conf_file).with_content(%r{-b}) }
      end
    end
  end

  describe 'On an unknown operating system' do
    let(:facts) { { osfamily: 'Unknown' } }

    it { expect { catalogue }.to raise_error(Puppet::PreformattedError, %r{expects a value for parameter}) }
  end
end
