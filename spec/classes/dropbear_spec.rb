require 'spec_helper'

describe 'dropbear' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts['os'] = {} unless facts['os'].is_a?(Hash)

        case os
        when %r{^(ubuntu-\d+.\d+|debian-\d+)-x86_64$}
          facts['os']['family'] = 'Debian'
        when %r{^freebsd-\d+-amd64$}
          facts['os']['family'] = 'FreeBSD'
        when %r{^(redhat|centos|fedora)-\d+-x86_64$}
          facts['os']['family'] = 'RedHat'
        end
        facts
      end

      conf_file = facts[:osfamily] == 'RedHat' ? '/etc/sysconfig/dropbear' : '/etc/default/dropbear'
      service_name = 'dropbear'

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

      context 'Using old-style arguments' do
        context 'When an alternate port is given' do
          let(:params) { { port: '42' } }

          it { is_expected.to contain_file(conf_file).with_content(%r{(=42$|-p 42 )}) }
        end
        context 'When an invalid alternate port is given' do
          let(:params) { { port: '66000' } }

          it { is_expected.to contain_file(conf_file).with_content(%r{(=66000$|-p 66000 )}) }
        end
        context 'When receive_window is given' do
          let(:params) { { receive_window: '131072' } }

          it { is_expected.to contain_file(conf_file).with_content(%r{131072}) }
        end
        context 'When no_start is 0 and start_service is false' do
          let(:params) { { no_start: '0', start_service: false } }

          it { is_expected.to contain_service(service_name).with({ 'ensure' => false }) }
        end
        context 'When no_start is 1 and start_service is true' do
          let(:params) { { no_start: '1', start_service: true } }

          it { is_expected.to contain_service(service_name).with({ 'ensure' => false }) }
        end
      end
      context 'When an alternate port is given' do
        let(:params) { { port: 42 } }

        it { is_expected.to contain_file(conf_file).with_content(%r{(=42$|-p 42 )}) }
      end
      context 'When an invalid alternate port is given' do
        let(:params) { { port: 66000 } }

        it { expect { catalogue }.to raise_error(Puppet::PreformattedError, %r{expects a value of type Stdlib::Port}) }
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
