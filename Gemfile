source 'https://rubygems.org'

if ENV.key?('PUPPET_GEM_VERSION')
  puppetversion = ENV['PUPPET_GEM_VERSION']
else
  puppetversion = ['>= 3.0']
end

gem 'rake', '10.1.0'
gem 'puppet-lint'
gem 'rspec-puppet'
gem 'puppet-syntax'
gem 'puppet', puppetversion
gem 'puppetlabs_spec_helper'
gem 'rspec-system'
gem 'rspec-system-puppet'
gem 'rspec-system-serverspec'
