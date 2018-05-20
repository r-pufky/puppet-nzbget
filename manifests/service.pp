# == Class nzbget::service
#
# This class is meant to be called from nzbget.
# It ensure the service is running.
#

class nzbget::service {
  if ($::nzbget::params::use_systemd == true) {
   file { '/etc/systemd/system/nzbget.service':
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      require => Package[$::nzbget::params::packages],
      content => template('nzbget/nzbget.systemd.erb'),
    }

    service { 'nzbget':
      ensure     => $::nzbget::service_ensure,
      enable     => $::nzbget::service_enable,
      hasrestart => true,
      hasstatus  => true,
      provider   => 'systemd',
      subscribe  => Concat[$::nzbget::params::config_file],
    }

    File['/etc/systemd/system/nzbget.service'] ~> Service['nzbget']
  } else {
    file { '/etc/init.d/nzbget':
      owner   => 'root',
      group   => 'root',
      mode    => '0755',
      content => template('nzbget/nzbget.sysv.erb'),
    }

    service { 'nzbget':
      ensure     => $::nzbget::service_ensure,
      enable     => $::nzbget::service_enable,
      hasrestart => true,
      hasstatus  => true,
      subscribe  => Concat[$::nzbget::params::config_file],
    }

    File['/etc/init.d/nzbget'] ~> Service['nzbget']
  }
}
