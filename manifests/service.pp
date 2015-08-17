# == Class nzbget::service
#
# This class is meant to be called from nzbget.
# It ensure the service is running.
#
class nzbget::service {

  file { '/etc/init/nzbget.conf':
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('nzbget/nzbget.upstart.erb'),
  }

  service { 'nzbget':
    ensure     => $::nzbget::service_ensure,
    enable     => $::nzbget::service_enable,
    hasrestart => false,
    hasstatus  => true,
    provider   => 'upstart',
  }

  File['/etc/init/nzbget.conf'] ~> Service['nzbget']
}
