# == Class nzbget::install
#
# This class is called from nzbget for install.
#
class nzbget::install {

  wget::fetch { 'nzbget download':
    source      => $::nzbget::source_url,
    destination => $::nzbget::destination_file,
  }

  exec { 'nzbget install':
    command => "sh ${::nzbget::destination_file} --destdir \
    ${::nzbget::install_dir}",
    creates => $::nzbget::install_dir,
    path    => '/bin',
  }

  if $::nzbget::manage_user {
    user { $::nzbget::user:
      ensure     => present,
      comment    => 'NZBGet user',
      home       => $::nzbget::install_dir,
      managehome => false,
      system     => true,
    }
  }

  Wget::Fetch['nzbget download'] -> Exec['nzbget install']
}
