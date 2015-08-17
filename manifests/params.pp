# == Class nzbget::params
#
# This class is meant to be called from nzbget.
# It sets variables according to platform.
#
class nzbget::params {
  # Install params
  $cache_dir        = '/var/cache/wget'
  $destination_file = '/srv/nzbget-bin-linux.run'
  $install_dir      = '/srv/nzbget'
  $manage_user      = true
  $source_url       = 'https://github.com/nzbget/nzbget/releases/download/v15.0/nzbget-15.0-bin-linux.run'
  $user             = 'nzbget'

  # Config params
  $config_file = "${install_dir}/nzbget.conf"

  $config_template = '${AppDir}/webui/nzbget.conf.template'
  $dest_dir        = '${MainDir}/completed'
  $inter_dir       = '${MainDir}/intermediate'
  $lock_file       = '${MainDir}/nzbget.lock'
  $log_file        = '${MainDir}/nzbget.log'
  $main_dir        = '${AppDir}/downloads'
  $nzb_dir         = '${MainDir}/nzb'
  $queue_dir       = '${MainDir}/queue'
  $script_dir      = '${AppDir}/scripts'
  $temp_dir        = '${MainDir}/tmp'
  $web_dir         = '${AppDir}/webui'

  $servers = [{
              'active'      => 'yes',
              'name'        => '',
              'level'       => 0,
              'group'       => 0,
              'host'        => 'my.newsserver.com',
              'port'        => 119,
              'username'    => 'user',
              'password'    => 'pass',
              'join_group'  => 'no',
              'encryption'  => 'no',
              'cipher'      => '',
              'connections' => 4,
              'retention'   => 0
              }]

  $add_password        = ''
  $add_username        = ''
  $authorized_ip       = '127.0.0.1'
  $control_ip          = '0.0.0.0'
  $control_password    = 'tegbzn6789'
  $control_port        = 6789
  $control_username    = 'nzbget'
  $daemon_username     = $user
  $restricted_password = ''
  $restricted_username = ''
  $secure_cert         = ''
  $secure_control      = 'no'
  $secure_key          = ''
  $secure_port         = 6791
  $umask               = 1000

  $categories = [ {
                  'name'        => 'movies',
                  'dest_dir'    => '',
                  'unpack'      => 'yes',
                  'post_script' => [],
                  'aliases'     => [],
                  },
                  { 'name' => 'Series' },
                  { 'name' => 'Music' },
                  { 'name' => 'Software' }]

  $rss_feeds = []

  $append_category_dir = 'yes'
  $dupe_check          = 'yes'
  $nzb_dir_file_age    = 60
  $nzb_dir_interval    = 5

  $accurate_rate       = 'no'
  $article_cache       = 100
  $article_timeout     = 60
  $continue_partial    = 'yes'
  $crc_check           = 'yes'
  $decode              = 'yes'
  $delete_cleanup_disk = 'yes'
  $direct_write        = 'yes'
  $disk_space          = 250
  $download_rate       = 0
  $feed_history        = 7
  $keep_history        = 30
  $nzb_cleanup_disk    = 'yes'
  $propagation_delay   = 0
  $reload_queue        = 'yes'
  $retries             = 3
  $retry_interval      = 10
  $save_queue          = 'yes'
  $terminate_timeout   = 600
  $url_connections     = 4
  $url_force           = 'yes'
  $url_timeout         = 60
  $write_buffer        = 1024

  $broken_log      = 'yes'
  $debug_target    = 'log'
  $detail_target   = 'log'
  $dump_core       = 'no'
  $error_target    = 'both'
  $info_target     = 'both'
  $log_buffer_size = 1000
  $nzb_log         = 'yes'
  $rotate_log      = 3
  $time_correction = 0
  $warning_target  = 'both'
  $write_log       = 'append'

  $curses_group    = 'no'
  $curses_nzb_name = 'yes'
  $curses_time     = 'no'
  $output_mode     = 'curses'
  $update_interval = 200

  $tasks = []

  $health_check      = 'delete'
  $par_buffer        = 100
  $par_check         = 'auto'
  $par_cleanup_queue = 'yes'
  $par_ignore_ect    = ['.sfv', '.nzb', '.nfo']
  $par_pause_queue   = 'no'
  $par_quick         = 'yes'
  $par_rename        = 'yes'
  $par_repair        = 'yes'
  $par_scan          = 'auto'
  $par_threads       = 0
  $par_time_limit    = 0

  $ext_cleanup_disk    = ['.par2', '.sfv', '_brokenlog.txt']
  $seven_zip_cmd       = '${AppDir}/7za'
  $unpack              = 'yes'
  $unpack_cleanup_disk = 'yes'
  $unpack_pass_file    = ''
  $unpack_pause_queue  = 'no'
  $unrar_cmd           = '${AppDir}/unrar'

  $event_interval     = 0
  $post_script        = ''
  $queue_script       = ''
  $scan_script        = ''
  $script_order       = ''
  $script_pause_queue = 'no'

  # Service params
  $service_enable = true
  $service_ensure = true

  case $::osfamily {
    'Debian': {
    }
    'RedHat', 'Amazon': {
    }
    default: {
      fail("${::operatingsystem} not supported")
    }
  }
}
