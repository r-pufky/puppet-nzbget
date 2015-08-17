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

  concat::fragment { 'categories':
    target  => $::nzbget::config_file,
    content => template('nzbget/nzbget.conf_categories.erb'),
  }

  concat::fragment { 'display':
    target  => $::nzbget::config_file,
    content => template('nzbget/nzbget.conf_display.erb'),
  }

  concat::fragment { 'download':
    target  => $::nzbget::config_file,
    content => template('nzbget/nzbget.conf_download.erb'),
  }

  concat::fragment { 'extension':
    target  => $::nzbget::config_file,
    content => template('nzbget/nzbget.conf_extension.erb'),
  }

  concat::fragment { 'incoming':
    target  => $::nzbget::config_file,
    content => template('nzbget/nzbget.conf_incoming.erb'),
  }

  concat::fragment { 'logging':
    target  => $::nzbget::config_file,
    content => template('nzbget/nzbget.conf_logging.erb'),
  }

  concat::fragment { 'par':
    target  => $::nzbget::config_file,
    content => template('nzbget/nzbget.conf_par.erb'),
  }

  concat::fragment { 'paths':
    target  => $::nzbget::config_file,
    content => template('nzbget/nzbget.conf_paths.erb'),
  }

  concat::fragment { 'rss':
    target  => $::nzbget::config_file,
    content => template('nzbget/nzbget.conf_rss.erb'),
  }

  concat::fragment { 'scheduler':
    target  => $::nzbget::config_file,
    content => template('nzbget/nzbget.conf_scheduler.erb'),
  }

  concat::fragment { 'security':
    target  => $::nzbget::config_file,
    content => template('nzbget/nzbget.conf_security.erb'),
  }

  concat::fragment { 'servers':
    target  => $::nzbget::config_file,
    content => template('nzbget/nzbget.conf_rss.erb'),
  }

  concat::fragment { 'unpack':
    target  => $::nzbget::config_file,
    content => template('nzbget/nzbget.conf_unpack.erb'),
  }
}
