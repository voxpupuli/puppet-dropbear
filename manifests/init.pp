# == Class: dropbear
#
# Install and configure dropbear using puppet.
#
# === Parameters
#
# [*no_start*]
#   Integer (0|1) used to prevent dropbear start.
#   Default: 0
#
# [*port*]
#   Integer, dropbear listen port
#   Default: 22
#
# [*extra_args*]
#   Extra argument passed to dropbear deamon (see man)
#   Default: nil
#
# [*banner*]
#   Display the contents of the file banner before user login.
#   Default: nil
#
# [*receive_window*]
#   Specify the per-channel receive window buffer size.
#   Increasing this may improve network performance at the expense of memory use.
#   Use -h to see the default buffer size.
#   Default: 65536
#
# === Variables
#
# [*package_name*]
#   Dropbear package name.
#
# [*package_version*]
#    Version of the Dropbear package
#
# [*service_name*]
#   Dropbear service name.
#
# [*start_service*]
#    Boolean to control whether to ensure the service is running
#
# [*rsakey*]
#   Use the contents of the file rsakey for the rsa host key
#   (default: /etc/dropbear/dropbear_rsa_host_key).
#   This file is generated with dropbearkey
#
# [*dsskey*]
#   Use the contents of the file dsskey for the DSS host key
#   (default: /etc/dropbear/dropbear_dss_host_key).
#   Note that some SSH implementations use the term "DSA" rather than "DSS",
#   they mean the same thing. This file is generated with dropbearkey.
#
# [*cfg_file*]
#   Location of configuration file.
#
# [*cfg_template*]
#   Location of configuration template.
#
#
# === Examples
#
#  include 'dropbear'
#
#   or
#
#  class {
#    'dropbear':
#      port            => 443,
#      extra_args      => '-s',
#      banner          => '/etc/banner',
#  }
#
# === Authors
#
# Kyle Anderson <kyle@xkyle.com>
# Sebastien Badia <seb@sebian.fr>
#
# === Copyright
#
# Copyleft 2013 Sebastien Badia.
# See LICENSE file.
#
class dropbear (
  String[1] $package_name,
  String[1] $service_name,
  Stdlib::Absolutepath $rsakey,
  Stdlib::Absolutepath $dsskey,
  Stdlib::Absolutepath $cfg_file,
  String $cfg_template,
  String[1] $package_version                              = 'installed',
  Boolean $start_service                                  = true,
  Optional[Enum['0', '1']] $no_start                      = undef,
  Variant[Stdlib::Port, Pattern[/^\d+$/]] $port           = 22,
  String $extra_args                                      = '',
  Optional[String[1]] $banner                             = undef,
  Variant[Integer[1], Pattern[/^\d+$/]] $receive_window   = 65536,
) {

  validate_legacy(Stdlib::Port, 'validate_re', $port, '^\d+$', 'port is not a valid number')
  validate_legacy(Integer, 'validate_re', $receive_window, '^\d+$', 'receive_window is not a valid number')
  $port_int = Integer($port)
  $receive_window_int = Integer($receive_window)

  package {
    $package_name:
      ensure => $package_version,
  }

  service {
    $service_name:
      ensure     => $start_service,
      hasrestart => true,
      hasstatus  => false,
      require    => Package[$package_name],
  }

  file {
    $cfg_file:
      ensure  => file,
      content => epp($cfg_template),
      owner   => root,
      group   => root,
      mode    => '0444',
      notify  => Service[$service_name],
      require => Package[$package_name],
  }

} # Class:: dropbear
