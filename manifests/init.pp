# Class: nzbget
# ===========================
#
# Full description of class nzbget here.
#
# Parameters
# ----------
#
# * `sample parameter`
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
class nzbget (
  # Install params
  $cache_dir        = $::nzbget::params::cache_dir,
  $destination_file = $::nzbget::params::destination_file,
  $install_dir      = $::nzbget::params::install_dir,
  $manage_user      = $::nzbget::params::manage_user,
  $source_url       = $::nzbget::params::source_url,
  $user             = $::nzbget::params::user,

  # Config params
  $config_file = $::nzbget::params::config_file,

  $config_template = $::nzbget::params::config_template,
  $dest_dir        = $::nzbget::params::dest_dir,
  $inter_dir       = $::nzbget::params::inter_dir,
  $lock_file       = $::nzbget::params::lock_file,
  $log_file        = $::nzbget::params::log_file,
  $main_dir        = $::nzbget::params::main_dir,
  $nzb_dir         = $::nzbget::params::nzb_dir,
  $queue_dir       = $::nzbget::params::queue_dir,
  $script_dir      = $::nzbget::params::script_dir,
  $temp_dir        = $::nzbget::params::temp_dir,
  $web_dir         = $::nzbget::params::web_dir,

  $servers = $::nzbget::params::servers,

  $add_password        = $::nzbget::params::add_password,
  $add_username        = $::nzbget::params::add_username,
  $authorized_ip       = $::nzbget::params::authorized_ip,
  $control_ip          = $::nzbget::params::control_ip,
  $control_password    = $::nzbget::params::control_password,
  $control_port        = $::nzbget::params::control_port,
  $control_username    = $::nzbget::params::control_username,
  $daemon_username     = $::nzbget::params::daemon_username,
  $restricted_password = $::nzbget::params::restricted_password,
  $restricted_username = $::nzbget::params::restricted_username,
  $secure_cert         = $::nzbget::params::secure_cert,
  $secure_control      = $::nzbget::params::secure_control,
  $secure_key          = $::nzbget::params::secure_key,
  $secure_port         = $::nzbget::params::secure_port,
  $umask               = $::nzbget::params::umask,

  $categories = $::nzbget::params::categories,

  $rss_feeds = $::nzbget::params::rss_feeds,

  $append_category_dir = $::nzbget::params::append_category_dir,
  $dupe_check          = $::nzbget::params::dupe_check,
  $nzb_dir_file_age    = $::nzbget::params::nzb_dir_file_age,
  $nzb_dir_interval    = $::nzbget::params::nzb_dir_interval,

  $accurate_rate       = $::nzbget::params::accurate_rate,
  $article_cache       = $::nzbget::params::article_cache,
  $article_timeout     = $::nzbget::params::article_timeout,
  $continue_partial    = $::nzbget::params::continue_partial,
  $crc_check           = $::nzbget::params::crc_check,
  $decode              = $::nzbget::params::decode,
  $delete_cleanup_disk = $::nzbget::params::delete_cleanup_disk,
  $direct_write        = $::nzbget::params::direct_write,
  $disk_space          = $::nzbget::params::disk_space,
  $download_rate       = $::nzbget::params::download_rate,
  $feed_history        = $::nzbget::params::feed_history,
  $keep_history        = $::nzbget::params::keep_history,
  $nzb_cleanup_disk    = $::nzbget::params::nzb_cleanup_disk,
  $propagation_delay   = $::nzbget::params::propagation_delay,
  $reload_queue        = $::nzbget::params::reload_queue,
  $retries             = $::nzbget::params::retries,
  $retry_interval      = $::nzbget::params::retry_interval,
  $save_queue          = $::nzbget::params::save_queue,
  $terminate_timeout   = $::nzbget::params::terminate_timeout,
  $url_connections     = $::nzbget::params::url_connections,
  $url_force           = $::nzbget::params::url_force,
  $url_timeout         = $::nzbget::params::url_timeout,
  $write_buffer        = $::nzbget::params::write_buffer,

  $broken_log      = $::nzbget::params::broken_log,
  $debug_target    = $::nzbget::params::debug_target,
  $detail_target   = $::nzbget::params::detail_target,
  $dump_core       = $::nzbget::params::dump_core,
  $error_target    = $::nzbget::params::error_target,
  $info_target     = $::nzbget::params::info_target,
  $log_buffer_size = $::nzbget::params::log_buffer_size,
  $nzb_log         = $::nzbget::params::nzb_log,
  $rotate_log      = $::nzbget::params::rotate_log,
  $time_correction = $::nzbget::params::time_correction,
  $warning_target  = $::nzbget::params::warning_target,
  $write_log       = $::nzbget::params::write_log,

  $curses_group    = $::nzbget::params::curses_group,
  $curses_nzb_name = $::nzbget::params::curses_nzb_name,
  $curses_time     = $::nzbget::params::curses_time,
  $output_mode     = $::nzbget::params::output_mode,
  $update_interval = $::nzbget::params::update_interval,

  $tasks = $::nzbget::params::tasks,

  $health_check      = $::nzbget::params::health_check,
  $par_buffer        = $::nzbget::params::par_buffer,
  $par_check         = $::nzbget::params::par_check,
  $par_cleanup_queue = $::nzbget::params::par_cleanup_queue,
  $par_ignore_ect    = $::nzbget::params::par_ignore_ect,
  $par_parse_queue   = $::nzbget::params::par_parse_queue,
  $par_quick         = $::nzbget::params::par_quick,
  $par_rename        = $::nzbget::params::par_rename,
  $par_repair        = $::nzbget::params::par_repair,
  $par_scan          = $::nzbget::params::par_scan,
  $par_threads       = $::nzbget::params::par_threads,
  $par_time_limit    = $::nzbget::params::par_time_limit,

  $ext_cleanup_disk    = $::nzbget::params::ext_cleanup_disk,
  $seven_zip_cmd       = $::nzbget::params::seven_zip_cmd,
  $unpack              = $::nzbget::params::unpack,
  $unpack_cleanup_disk = $::nzbget::params::unpack_cleanup_disk,
  $unpack_pass_file    = $::nzbget::params::unpack_pass_file,
  $unpack_pause_queue  = $::nzbget::params::unpack_pause_queue,
  $unrar_cmd           = $::nzbget::params::unrar_cmd,

  $event_interval     = $::nzbget::params::event_interval,
  $post_script        = $::nzbget::params::post_script,
  $queue_script       = $::nzbget::params::queue_script,
  $scan_script        = $::nzbget::params::scan_script,
  $script_order       = $::nzbget::params::script_order,
  $script_pause_queue = $::nzbget::params::script_pause_queue,

  # Service params
  $service_ensure = $::nzbget::params::service_ensure,
  $service_enable = $::nzbget::params::service_enable,
  ) inherits ::nzbget::params {

  # Install params
  validate_absolute_path($cache_dir, $destination_file, $install_dir)
  validate_bool($manage_user)
  validate_string($source_url, $user)

  # Config params
  validate_absolute_path($config_file)
  validate_array($servers, $categories, $rss_feeds, $tasks,
  $par_ignore_ect, $ext_cleanup_disk)
  validate_integer($control_port)
  validate_integer($secure_port)
  validate_integer($umask)
  validate_integer($nzb_dir_file_age)
  validate_integer($nzb_dir_interval)
  validate_integer($article_cache)
  validate_integer($article_timeout)
  validate_integer($disk_space)
  validate_integer($download_rate)
  validate_integer($feed_history)
  validate_integer($keep_history)
  validate_integer($propagation_delay)
  validate_integer($retries)
  validate_integer($retry_interval)
  validate_integer($terminate_timeout)
  validate_integer($url_connections)
  validate_integer($url_timeout)
  validate_integer($write_buffer)
  validate_integer($log_buffer_size)
  validate_integer($rotate_log)
  validate_integer($time_correction)
  validate_integer($update_interval)
  validate_integer($par_buffer)
  validate_integer($par_threads)
  validate_integer($par_time_limit)
  validate_integer($event_interval)
  validate_string($config_template, $dest_dir, $inter_dir, $lock_file,
  $log_file, $main_dir, $nzb_dir, $queue_dir, $script_dir, $temp_dir,
  $web_dir, $add_password, $add_username, $authorized_ip, $control_ip,
  $control_password, $control_username, $daemon_username,
  $restricted_password, $restricted_username, $secure_cert,
  $secure_control, $secure_key, $append_category_dir, $dupe_check,
  $accurate_rate, $continue_partial, $crc_check, $decode,
  $delete_cleanup_disk, $direct_write, $nzb_cleanup_disk,
  $reload_queue, $save_queue, $url_force, $broken_log, $debug_target,
  $detail_target, $dump_core, $error_target, $info_target, $nzb_log,
  $warning_target, $write_log, $curses_group, $curses_nzb_name,
  $curses_time, $output_mode, $health_check, $par_check,
  $par_cleanup_queue, $par_parse_queue, $par_quick, $par_rename,
  $par_repair, $par_scan, $seven_zip_cmd, $unpack,
  $unpack_cleanup_disk, $unpack_pass_file, $unpack_pause_queue,
  $unrar_cmd, $post_script, $queue_script, $scan_script,
  $script_order, $script_pause_queue)

  # Service params
  validate_bool($service_enable, $service_ensure)

  class { '::nzbget::install': } ->
  class { '::nzbget::config': } ~>
  class { '::nzbget::service': } ->
  Class['::nzbget']
}
