# Puppet-dropbear

[![Build Status](https://travis-ci.org/voxpupuli/puppet-dropbear.png?branch=master)](https://travis-ci.org/voxpupuli/puppet-dropbear)
[![Puppet Forge](http://img.shields.io/puppetforge/v/voxpupuli/dropbear.svg)](https://forge.puppetlabs.com/voxpupuli/dropbear)
[![Puppet Forge - downloads](https://img.shields.io/puppetforge/dt/puppet/dropbear.svg)](https://forge.puppetlabs.com/puppet/dropbear)
[![Puppet Forge - endorsement](https://img.shields.io/puppetforge/e/puppet/dropbear.svg)](https://forge.puppetlabs.com/puppet/dropbear)
[![Puppet Forge - scores](https://img.shields.io/puppetforge/f/puppet/dropbear.svg)](https://forge.puppetlabs.com/puppet/dropbear)
[![License](http://img.shields.io/:license-gpl3-blue.svg)](http://www.gnu.org/licenses/gpl-3.0.html)

Manage [dropbear](https://matt.ucc.asn.au/dropbear/dropbear.html) SSH server via Puppet

## Overview

Dropbear is a relatively small SSH server and client. It runs on a variety of POSIX-based platforms. Dropbear is open source software, distributed under a MIT-style license. Dropbear is particularly useful for "embedded"-type Linux (or other Unix) systems, such as wireless routers.

## Usage

### Using default values

```puppet
include 'dropbear'
```

### Overide values

```puppet
class { 'dropbear':
  port       => '443',
  extra_args => '-s',
  banner     => '/etc/banner',
}
```

## Other class parameters

* `no_start`: boolean, 0 for start dropbear, and 1 for stop (init), (default: 0, start)
* `port`: integer, ssh TCP port listens on (default: 22)
* `extra_args`: string, dropbear ssh args (refs: man dropbear)
* `banner`: string, banner file containing a message to be sent to clients before they connect
* `rsakey`: string, RSA hostkey file (default: /etc/dropbear/dropbear\_rsa\_host\_key)
* `dsskey`: string, DSS hostkey file (default: /etc/dropbear/dropbear\_dss\_host\_key)
* `receive_window`: string, Receive window size, this is a tradeoff between memory and network performance (default: 65536)

# Contributors

* https://github.com/voxpupuli/puppet-dropbear/graphs/contributors

# Beaker-Rspec

This module has beaker-rspec tests

To run:

```shell
bundle install
bundle exec rspec spec/acceptance
# or use BEAKER_destroy=no to keep the resulting vm
BEAKER_destroy=no bundle exec rspec spec/acceptance
```

# Release Notes

See [CHANGELOG](https://github.com/voxpupuli/puppet-dropbear/blob/master/CHANGELOG.md) file.

## Development

[Feel free to contribute](https://github.com/voxpupuli/puppet-dropbear/). I'm not a big fan of centralized services like GitHub but I used it to permit easy pull-requests, so show me that's a good idea!

## Authors

This module got migrated from sbadia to Vox Pupuli
