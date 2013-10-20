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
  $service_name   = $dropbear::params::service_name,
  $no_start       = '0',
  $port           = '22',
  $extra_args     = '',
  $banner         = '',
  $rsakey         = $dropbear::params::rsakey,
  $dsskey         = $dropbear::params::dsskey,
  $cfg_file       = $dropbear::params::cfg_file,
  $cfg_template   = $dropbear::params::cfg_template,
  $receive_window = '65536'
) inherits dropbear::params {

  package {
    $package_name:
      ensure => installed;
  }

  service {
    $service_name:
      ensure      => running,
      hasrestart  => true,
      hasstatus   => false,
      require     => Package[$package_name];
  }

  file {
    $cfg_file:
      ensure  => file,
      content => template($cfg_template),
      owner   => root,
      group   => root,
      mode    => '0444',
      notify  => Service[$service_name],
      require => Package[$package_name];
  }

} # Class:: dropbear
