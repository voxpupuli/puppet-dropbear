# @summary Install and configure dropbear using puppet.
#
# @author Kyle Anderson <kyle@xkyle.com>
#
# @param no_start
#   Integer (0|1) used to prevent dropbear start.
# @param port
#   Integer, dropbear listen port
# @param extra_args
#   Extra argument passed to dropbear deamon (see man)
# @param banner
#   Display the contents of the file banner before user login.
# @param receive_window
#   Specify the per-channel receive window buffer size.
#   Increasing this may improve network performance at the expense of memory use.
#   Use -h to see the default buffer size.
# @param package_name
#   Dropbear package name.
# @param package_version
#    Version of the Dropbear package
# @param service_name
#   Dropbear service name.
# @param start_service
#    Boolean to control whether to ensure the service is running
# @param rsakey
#   Use the contents of the file rsakey for the rsa host key
#   This file is generated with dropbearkey
# @param dsskey
#   Use the contents of the file dsskey for the DSS host key
#   Note that some SSH implementations use the term "DSA" rather than "DSS",
#   they mean the same thing. This file is generated with dropbearkey.
# @param cfg_file
#   Location of configuration file.
# @param cfg_template
#   Location of configuration template.
#
# @example Install Dropbear
#  include 'dropbear'
#
# @example Install Dropbear with no-default configuration.
#  class { 'dropbear':
#      port       => 443,
#      extra_args => '-s',
#      banner     => '/etc/banner',
#  }
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
  $port_int = Integer($port)
  if $port_int !~ Stdlib::Port {
    fail("Port ${port_int} is not a valid port number")
  }
  validate_legacy(Integer, 'validate_re', $receive_window, '^\d+$', 'receive_window is not a valid number')
  $receive_window_int = Integer($receive_window)

  $dep_warning_nostart = 'The dropbear::no_start parameter is deprecated. If you do not want to manage the dropbear service, use the dropbear::manage_service option.'
  if $no_start {
    deprecation('dropbear::nostart', $dep_warning_nostart)
    if $no_start == '0' and ! $start_service {
      warning('dropbear::no_start is 0 and dropbear::start_service is false.  Using manage_service.')
      $_start_service = $start_service
    } elsif $no_start == '1' and $start_service {
      warning('dropbear::no_start is 1 and dropbear::start_service is true.  Using no_start.')
      $_start_service = false
    } else {
      $_start_service = $start_service
    }
  } else {
    $_start_service = $start_service
  }

  package {
    $package_name:
      ensure => $package_version,
  }

  service {
    $service_name:
      ensure     => $_start_service,
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
