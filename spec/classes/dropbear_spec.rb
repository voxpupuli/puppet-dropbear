require 'spec_helper'

describe 'dropbear' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      default_params = {
        cfg_file: '/etc/sysconfig/dropbear'
      }

      let(:facts) do
        facts
      end
      let(:params) do
        default_params
      end

      context 'with all defaults' do
        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_class('dropbear') }
        it { is_expected.to contain_package('dropbear') }
        it { is_expected.to contain_service('dropbear') }

        it {
          is_expected.to contain_file('/etc/sysconfig/dropbear').with(
            'owner' => 'root',
            'group' => 'root',
            'mode'  => '0444'
          )
        }
      end

      context 'Using old-style arguments' do
        context 'When an alternate port is given' do
          let(:params) { default_params.merge({ port: 42 }) }

          it { is_expected.to contain_file('/etc/sysconfig/dropbear').with_content(%r{(=42$|-p 42 )}) }
        end

        context 'When an invalid alternate port is given' do
          let(:params) { default_params.merge({ port: 66_000 }) }

          it { expect { catalogue }.to raise_error(Puppet::PreformattedError) }
        end

        context 'When receive_window is given' do
          let(:params) { default_params.merge({ receive_window: 131_072 }) }

          it { is_expected.to contain_file('/etc/sysconfig/dropbear').with_content(%r{131072}) }
        end

        context 'When no_start is 0 and start_service is false' do
          let(:params) { default_params.merge({ no_start: '0', start_service: false }) }

          it { is_expected.to contain_service('dropbear').with('ensure' => false) }
        end

        context 'When no_start is 1 and start_service is true' do
          let(:params) { default_params.merge({ no_start: '1', start_service: true }) }

          it { is_expected.to contain_service('dropbear').with('ensure' => false) }
        end
      end

      describe 'with specific parameters' do
        context 'When an alternate port is given' do
          let(:params) { default_params.merge({ port: 42 }) }

          it { is_expected.to contain_file('/etc/sysconfig/dropbear').with_content(%r{(=42$|-p 42 )}) }
        end

        context 'When an invalid alternate port is given' do
          let(:params) { default_params.merge({ port: 66_000 }) }

          it { expect { catalogue }.to raise_error(Puppet::PreformattedError) }
        end

        context 'When a banner is specified' do
          let(:params) { default_params.merge({ banner: '/etc/test_banner' }) }

          it { is_expected.to contain_file('/etc/sysconfig/dropbear').with_content(%r{/etc/test_banner}) }
        end

        context 'When a banner is NOT specified' do
          it { is_expected.to contain_file('/etc/sysconfig/dropbear').without_content(%r{-b}) }
        end
      end
    end
  end
end
