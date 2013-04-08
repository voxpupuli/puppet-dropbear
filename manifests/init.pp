# Module:: dropbear
# Manifest:: init.pp
#
# Author:: Sebastien Badia (<seb@sebian.fr>)
# Date:: 2013-04-08 16:35:51 +0200
# Maintainer:: Sebastien Badia (<seb@sebian.fr>)
#

import 'params.pp'

# Class:: dropbear
#
#
class dropbear (
  $package_name   = $dropbear::params::package_name,
  $no_start       = '0',
  $ssh_port       = '22',
  $ssh_args       = '',
  $banner         = '',
  $rsakey         = $dropbear::params::rsakey,
  $dsskey         = $dropbear::params::dsskey,
  $receive_window = '65536'
) inherits dropbear::params {

  package {
    $package_name:
      ensure => installed;
  }

  service {
    'dropbear':
      ensure      => running,
      hasrestart  => true,
      hasstatus   => false,
      require     => Package['dropbear'];
  }

  file {
    '/etc/default/dropbear':
      ensure  => file,
      content => template('dropbear/dropbear.erb'),
      owner   => root,
      group   => root,
      mode    => '0644',
      notify  => Service['dropbear'],
      require => Package['dropbear'];
  }

} # Class:: dropbear
