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
# @param manage_config
#   Whether to let the module manage the config file or not.
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
  Boolean $manage_config                                  = true,
  String[1] $package_version                              = 'installed',
  Boolean $start_service                                  = true,
  Optional[Enum['0', '1']] $no_start                      = undef,
  Stdlib::Port $port                                      = 22,
  Optional[String[1]] $extra_args                         = undef,
  Optional[String[1]] $banner                             = undef,
  Integer[1] $receive_window                              = 65536,
) {
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

  package { $package_name:
    ensure => $package_version,
  }

  service { $service_name:
    ensure     => $_start_service,
    hasrestart => true,
    hasstatus  => false,
    require    => Package[$package_name],
  }

  if $manage_config {
    if $facts['os']['family'] == 'Redhat' {
      file { $cfg_file:
        ensure           => file,
        content          => epp('dropbear/redhat.epp',
          port           => $port,
          rsakey         => $rsakey,
          dsskey         => $dsskey,
          receive_window => $receive_window,
          banner         => $banner,
          extra_args     => $extra_args
        ),
        owner            => root,
        group            => root,
        mode             => '0444',
        notify           => Service[$service_name],
        require          => Package[$package_name],
      }
    } else {
      file { $cfg_file:
        ensure           => file,
        content          => epp('dropbear/debian.epp',
          port           => $port,
          rsakey         => $rsakey,
          dsskey         => $dsskey,
          receive_window => $receive_window,
          banner         => $banner,
          extra_args     => $extra_args,
          start_service  => $_start_service
        ),
        owner            => root,
        group            => root,
        mode             => '0444',
        notify           => Service[$service_name],
        require          => Package[$package_name],
      }
    }
  }
}
