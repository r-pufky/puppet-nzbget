# Class: nzbget
# ===========================
#
# For version 19.1 stable of NZBGet.
#
# Does not use NZBGet-styled relative paths (${MainDir}). Relative paths may be
#   used, and are relative to $service_dir. Absolute paths preferred.
#
# Uses default nzbget configuration values for ubuntu. Parameters correspond to
#   nzbget conf file settings:
#   https://github.com/nzbget/nzbget/blob/c0eedc342b422ea2797bc85a3fb19c0a2c60e716/nzbget.conf
#

class nzbget (
  # Puppet settings
  Boolean                   $manage_ppa           = true,
  Boolean                   $manage_user          = true,
  Tuple[Boolean, String]    $manage_service_dirs  = [true, '/home'],
  Tuple[Boolean, String]    $manage_data_dirs     = [true, '/home/nzbget'],
  Boolean                   $manage_certs         = true,
  Boolean                   $manage_pass_file     = true,
  String                    $user                 = 'nzbget',
  String                    $group                = 'nzbget',
  String                    $service_dir          = '/home/nzbget',
  String                    $config_file          = '/etc/nzbget.conf',
  Boolean                   $service_enable       = true,
  Boolean                   $service_ensure       = true,

  # Paths Section
  String                    $main_dir             = 'downloads',
  String                    $destination_dir      = 'dst',
  Optional[String]          $intermediate_dir     = 'inter',
  String                    $nzb_dir              = 'nzb',
  String                    $queue_dir            = 'queue',
  String                    $temp_dir             = 'tmp',
  Optional[String]          $web_dir              = '/usr/share/nzbget/webui',
  Array                     $script_dir           = ['scripts'],
  Optional[String]          $lock_file            = 'nzbget.lock',
  String                    $log_file             = 'dst/nzbget.log',
  String                    $config_template      = '/usr/share/nzbget/nzbget.conf',
  Optional[Array[String]]   $required_dir         = undef,
  Optional[String]          $cert_store           = undef,

  # Servers Section
  Optional[Array[Struct[{
    active                  => Boolean,
    Optional[name]          => String,
    level                   => Integer[0, 99],
    optional                => Boolean,
    group                   => Integer[0, 99],
    host                    => String,
    port                    => Integer[1, 65535],
    username                => String,
    password                => String,
    join_group              => Boolean,
    encryption              => Boolean,
    Optional[cipher]        => Array[String],
    connections             => Integer[0, 999],
    retention               => Integer,
    ip_version              => Enum['auto', 'ipv4', 'ipv6'],
    Optional[notes]         => String
  }]]]                      $servers              = [{
    active                  => true,
    name                    => 'my.newsserver.com',
    level                   => 0,
    optional                => false,
    group                   => 0,
    host                    => 'my.newsserver.com',
    port                    => 119,
    username                => 'user',
    password                => 'pass',
    join_group              => false,
    encryption              => false,
    connections             => 4,
    retention               => 0,
    ip_version              => 'auto',
  }],

  # Security Section
  String                    $control_ip           = '0.0.0.0',
  Integer[1, 65535]         $control_port         = 6789,
  Optional[String]          $control_username     = 'nzbget',
  Optional[String]          $control_password     = 'tegbzn6789',
  Optional[String]          $restricted_username  = undef,
  Optional[String]          $restricted_password  = undef,
  Optional[String]          $add_username         = undef,
  Optional[String]          $add_password         = undef,
  Boolean                   $form_auth            = false,
  Boolean                   $secure_control       = false,
  Integer[1, 65535]         $secure_port          = 6791,
  Optional[String]          $secure_cert          = undef,
  Optional[String]          $secure_key           = undef,
  Optional[Array[String]]   $authorized_ips       = undef,
  Boolean                   $cert_check           = false,
  String                    $daemon_username      = 'root',
  String                    $umask                = '1000',

  # Categories Section
  Optional[Array[Struct[{
    name                    => String,
    Optional[dest_dir]      => String,
    unpack                  => Boolean,
    Optional[extensions]    => Array[String],
    Optional[aliases]       => Array[String]
  }]]]                      $categories              = [{
    name                    => 'Movies',
    unpack                  => true
  }, {
    name                    => 'Series',
    unpack                  => true
  }, {
    name                    => 'Music',
    unpack                  => true
  }, {
    name                    => 'Software',
    unpack                  => true
  }],

  # RSS Feeds Section
  Optional[Array[Struct[{
    name                    => String,
    Optional[url]           => String,
    Optional[filter]        => Array[String],
    interval                => Integer,
    backlog                 => Boolean,
    pause_nzb               => Boolean,
    Optional[category]      => String,
    priority                => Integer,
    Optional[extensions]    => Array[String]
 }]]]                       $feeds                 = [{
    name                    => 'my feed',
    interval                => 15,
    backlog                 => true,
    pause_nzb               => false,
    priority                => 0
  }],

  # Incoming NZBs Section
  Boolean                   $append_category_dir  = true,
  Integer                   $nzb_dir_interval     = 5,
  Integer                   $nzb_dir_file_age     = 60,
  Boolean                   $dupe_check           = true,

  # Download Queue Section
  Boolean                   $save_queue           = true,
  Boolean                   $flush_queue          = true,
  Boolean                   $reload_queue         = true,
  Boolean                   $continue_partial     = true,
  Integer                   $propagation_delay    = 0,
  Boolean                   $decode               = true,
  Integer                   $article_cache        = 0,
  Boolean                   $direct_write         = true,
  Integer                   $write_buffer         = 0,
  Boolean                   $crc_check            = true,
  Enum['auto',
      'nzb',
      'article']            $file_naming          = 'auto',
  Boolean                   $reorder_files        = true,
  Enum['sequential',
      'balanced',
      'aggressive',
      'rocket']             $post_strategy        = 'balanced',
  Integer                   $disk_space           = 250,
  Boolean                   $nzb_cleanup_disk     = true,
  Integer                   $keep_history         = 30,
  Integer                   $feed_history         = 7,

  # Connection Section
  Integer[0, 99]            $article_retries      = 3,
  Integer                   $article_interval     = 10,
  Integer                   $article_timeout      = 60,
  Integer[0, 99]            $url_retries          = 3,
  Integer                   $url_interval         = 10,
  Integer                   $url_timeout          = 60,
  Integer                   $terminate_timeout    = 600,
  Integer                   $download_rate        = 0,
  Boolean                   $accurate_rate        = false,
  Integer[0, 999]           $url_connections      = 4,
  Boolean                   $url_force            = true,
  Integer                   $monthly_quota        = 0,
  Integer[1, 31]            $quota_start_day      = 1,
  Integer                   $daily_quota          = 0,

  # Logging Section
  Enum['none',
      'append',
      'reset',
      'rotate']             $write_log            = 'append',
  Integer                   $rotate_log           = 3,
  Enum['screen',
      'log',
      'both',
      'none']               $error_target         = 'both',
  Enum['screen',
      'log',
      'both',
      'none']               $warning_target       = 'both',
  Enum['screen',
      'log',
      'both',
      'none']               $info_target          = 'both',
  Enum['screen',
      'log',
      'both',
      'none']               $detail_target        = 'log',
  Enum['screen',
      'log',
      'both',
      'none']               $debug_target         = 'log',
  Integer                   $log_buffer_size      = 1000,
  Boolean                   $nzb_log              = true,
  Boolean                   $broken_log           = true,
  Boolean                   $crash_trace          = true,
  Boolean                   $crash_dump           = false,
  Integer                   $time_correction      = 0,

  # Display Section
  Enum['loggable',
      'colored',
      'curses']             $output_mode          = 'curses',
  Boolean                   $curses_nzb_name      = true,
  Boolean                   $curses_group         = false,
  Boolean                   $curses_time          = false,
  Integer[25]               $update_interval      = 200,

  # Scheduler Section
  Optional[Array[Struct[{
    Optional[time]          => Array[String],
    Optional[week_days]     => Array[String],
    command                 => Enum['PauseDownload',
                                  'UnpauseDownload',
                                  'PausePostProcess',
                                  'UnpausePostProcess',
                                  'PauseScan',
                                  'UnpauseScan',
                                  'DownloadRate',
                                  'Script',
                                  'Process',
                                  'ActivateServer',
                                  'DeactivateServer',
                                  'FetchFeed'],
    Optional[param]         => String
  }]]]                      $tasks                = undef,

  # Check and Repair Section
  Enum['auto',
      'always',
      'force',
      'manual']             $par_check            = 'auto',
  Boolean                   $par_repair           = true,
  Enum['limited',
      'extended',
      'full',
      'dupe']               $par_scan             = 'extended',
  Boolean                   $par_quick            = true,
  Integer                   $par_buffer           = 16,
  Integer[0, 99]            $par_threads          = 0,
  Optional[Array[String]]   $par_ignore_ext       = ['.sfv', '.nzb', '.nfo'],
  Boolean                   $par_rename           = true,
  Boolean                   $rar_rename           = true,
  Boolean                   $direct_rename        = false,
  Enum['delete',
      'park',
      'pause',
      'none']               $health_check         = 'park',
  Integer                   $par_time_limit       = 0,
  Boolean                   $par_pause_queue      = false,

  # Unpack Section
  Boolean                   $unpack               = true,
  Boolean                   $direct_unpack        = false,
  Boolean                   $unpack_pause_queue   = false,
  Boolean                   $unpack_cleanup_disk  = true,
  String                    $unrar_cmd            = 'unrar',
  String                    $seven_zip_cmd        = '7z',
  Optional[Array[String]]   $ext_cleanup_disk     = ['.par2', '.sfv', '_brokenlog.txt'],
  Optional[Array[String]]   $unpack_ignore_ext    = ['.cbr'],
  Optional[String]          $unpack_pass_file     = undef,

  # Extension Scripts
  Optional[Array[String]]   $extensions           = undef,
  Optional[Array[String]]   $script_order         = undef,
  Boolean                   $script_pause_queue   = false,
  Optional[Array[String]]   $shell_override       = undef,
  Integer[-1]               $event_interval       = 0,
) {
  if ($facts['os']['family'] != 'Debian') {
    fail "Your osfamily (${facts[os][family]}) is not supported by this module"
  }

  include ::nzbget::params
  include ::nzbget::install
  include ::nzbget::config
  include ::nzbget::service
}
