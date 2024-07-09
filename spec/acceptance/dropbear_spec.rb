require 'spec_helper_acceptance'

describe 'dropbear class' do
  context 'default parameters' do
    # Using puppet_apply as a helper
    it 'works idempotently with no errors' do
      pp = <<-EOS
      class { 'dropbear':
        port       => 443,
        extra_args => '-s',
        banner     => '/etc/motd',
      }
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end
  end
end
