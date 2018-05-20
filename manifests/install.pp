# == Class nzbget::install
#
# This class is called from nzbget for install.
#

class nzbget::install {
  if ($::nzbget::manage_ppa) {
    apt::ppa { 'ppa:modriscoll/nzbget': }

    apt::key { 'ppa:modriscoll/nzbget':
      id => '0x0778B73662C73F57DB254490780F1E2D6CDE748F'
    }

    package { 'nzbget':
      ensure  => present,
      require => [
        Apt::Ppa['ppa:modriscoll/nzbget'],
        Apt::Key['ppa:modriscoll/nzbget'],
        Class['apt::update'],
      ]
    }
  }

  package { $::nzbget::params::packages:
    ensure  => latest,
    require => Class['apt::update'],
  }

  group { $::nzbget::group:
      ensure     => present,
  } -> if ($::nzbget::manage_user) {
    user { $::nzbget::user:
      ensure     => present,
      comment    => 'NZBGet [Puppet Managed]',
      home       => $::nzbget::service_dir,
      membership => minimum,
      groups     => $::nzbget::params::user_resource_group,
      managehome => true,
      system     => true,
      password   => '!',
    }
  }
}
