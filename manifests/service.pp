# == Class nzbget::service
#
# This class is meant to be called from nzbget.
# It ensure the service is running.
#
class nzbget::service {

  service { 'nzbget':
    ensure     => $::nzbget::service_ensure,
    binary     => "${::nzbget::install_dir}/nzbget",
    enable     => $::nzbget::service_enable,
    hasrestart => false,
    hasstatus  => false,
    pattern    => 'nzbget\s*-D',
    provider   => 'base',
    start      => "${::nzbget::install_dir}/nzbget -D -c ${::nzbget::config_file}",
    stop       => "${::nzbget::install_dir}/nzbget -Q",
  }
}
