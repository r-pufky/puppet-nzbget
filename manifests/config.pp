# == Class nzbget::config
#
# This class is called from nzbget for service config.
#
class nzbget::config {

  File[$::nzbget::install_dir] -> Concat[$::nzbget::config_file]

  file { $::nzbget::install_dir:
    ensure  => directory,
    owner   => $::nzbget::user,
    recurse => true,
  }

  concat { $::nzbget::config_file:
    ensure => 'present',
    owner  => $::nzbget::user,
  }

  concat::fragment { 'paths':
    target  => $::nzbget::config_file,
    content => template('nzbget/nzbget.conf_paths.erb'),
    order   => '01',
  }

  concat::fragment { 'servers':
    target  => $::nzbget::config_file,
    content => template('nzbget/nzbget.conf_servers.erb'),
    order   => '03',
  }

  concat::fragment { 'security':
    target  => $::nzbget::config_file,
    content => template('nzbget/nzbget.conf_security.erb'),
    order   => '05',
  }

  concat::fragment { 'categories':
    target  => $::nzbget::config_file,
    content => template('nzbget/nzbget.conf_categories.erb'),
    order   => '07',
  }

  concat::fragment { 'rss':
    target  => $::nzbget::config_file,
    content => template('nzbget/nzbget.conf_rss.erb'),
    order   => '09',
  }

  concat::fragment { 'incoming':
    target  => $::nzbget::config_file,
    content => template('nzbget/nzbget.conf_incoming.erb'),
    order   => '11',
  }

  concat::fragment { 'download':
    target  => $::nzbget::config_file,
    content => template('nzbget/nzbget.conf_download.erb'),
    order   => '13',
  }

  concat::fragment { 'logging':
    target  => $::nzbget::config_file,
    content => template('nzbget/nzbget.conf_logging.erb'),
    order   => '15',
  }

  concat::fragment { 'display':
    target  => $::nzbget::config_file,
    content => template('nzbget/nzbget.conf_display.erb'),
    order   => '17',
  }

  concat::fragment { 'scheduler':
    target  => $::nzbget::config_file,
    content => template('nzbget/nzbget.conf_scheduler.erb'),
    order   => '19',
  }

  concat::fragment { 'par':
    target  => $::nzbget::config_file,
    content => template('nzbget/nzbget.conf_par.erb'),
    order   => '21',
  }

  concat::fragment { 'unpack':
    target  => $::nzbget::config_file,
    content => template('nzbget/nzbget.conf_unpack.erb'),
    order   => '23',
  }

  concat::fragment { 'extension':
    target  => $::nzbget::config_file,
    content => template('nzbget/nzbget.conf_extension.erb'),
    order   => '25',
  }

  concat::fragment { 'custom':
    target  => $::nzbget::config_file,
    content => template('nzbget/nzbget.conf_custom.erb'),
    order   => '27',
  }
}
