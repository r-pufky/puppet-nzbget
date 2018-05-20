# This function will apply all filters and return a unique, filtered array.
function nzb_dir_filter(Array $dirs, Array $filters) >> Array {
  $result = $filters.map |$filter| {
    if ($filter == '/') {
      $single_filter = dirtree($dirs)
    } else {
      $single_filter = dirtree($dirs.filter |$f| { $filter in $f }, $filter)
    }
  }
  delete(unique(flatten($result)), '')
}

# == Class nzbget::params
#
# This class is meant to be called from nzbget.
# It sets service params according to user preferences.
#
class nzbget::params {
  $packages = [
    'unrar',
    'par2',
    'parchive',
  ]

  $masks = [$::nzbget::manage_service_dirs[1], $::nzbget::manage_data_dirs[1]]

  # TODO: once ubuntu 14 support is removed from puppet, convert to systemd.
  if ($facts['os']['release']['full'] == '16.04') {
    $use_systemd = true
  } else {
    $use_systemd = false
  }

  if (!is_absolute_path($::nzbget::service_dir)) {
    fail "nzbget::service_dir MUST be an absolute path [${::nzbget::service_dir}]."
  }

  if (!is_absolute_path($::nzbget::config_file)) {
    $config_file = "${::nzbget::service_dir}/${::nzbget::config_file}"
    $config_file_dir = dirname($config_file)
  } else {
    $config_file = $::nzbget::config_file
    $config_file_dir = dirname($config_file)
  }

  if (!is_absolute_path($::nzbget::main_dir)) {
    $main_dir = "${::nzbget::service_dir}/${::nzbget::main_dir}"
  } else {
    $main_dir = $::nzbget::main_dir
  }

  if (!is_absolute_path($::nzbget::destination_dir)) {
    $destination_dir = "${::nzbget::service_dir}/${::nzbget::destination_dir}"
  } else {
    $destination_dir = $::nzbget::destination_dir
  }

  if ($::nzbget::intermediate_dir) {
    if (!is_absolute_path($::nzbget::intermediate_dir)) {
      $intermediate_dir = "${::nzbget::service_dir}/${::nzbget::intermediate_dir}"
    } else {
      $intermediate_dir = $::nzbget::intermediate_dir
    }
  } else {
    $intermediate_dir = undef
  }

  if (!is_absolute_path($::nzbget::nzb_dir)) {
    $nzb_dir = "${::nzbget::service_dir}/${::nzbget::nzb_dir}"
  } else {
    $nzb_dir = $::nzbget::nzb_dir
  }

  if (!is_absolute_path($::nzbget::queue_dir)) {
    $queue_dir = "${::nzbget::service_dir}/${::nzbget::queue_dir}"
  } else {
    $queue_dir = $::nzbget::queue_dir
  }

  if (!is_absolute_path($::nzbget::temp_dir)) {
    $temp_dir = "${::nzbget::service_dir}/${::nzbget::temp_dir}"
  } else {
    $temp_dir = $::nzbget::temp_dir
  }

  if ($::nzbget::web_dir) {
    if (!is_absolute_path($::nzbget::web_dir)) {
      $web_dir = "${::nzbget::service_dir}/${::nzbget::web_dir}"
    } else {
      $web_dir = $::nzbget::web_dir
    }
  } else {
    $web_dir = undef
  }

  $script_dir = $::nzbget::script_dir.map |$dir| {
    if (!is_absolute_path($dir)) {
      $required_abs_path = "${::nzbget::service_dir}/${dir}"
    } else {
      $required_abs_path = $dir
    }
  }

  if ($::nzbget::lock_file) {
    if (!is_absolute_path($::nzbget::lock_file)) {
      $lock_file = "${::nzbget::service_dir}/${::nzbget::lock_file}"
      $lock_dir = dirname($lock_file)
    } else {
      $lock_file = $::nzbget::lock_file
      $lock_dir = dirname($lock_file)
    }
  } else {
    $lock_file = undef
    $lock_dir = undef
  }

  if (!is_absolute_path($::nzbget::log_file)) {
    $log_file = "${::nzbget::service_dir}/${::nzbget::log_file}"
    $log_dir = dirname($log_file)
  } else {
    $log_file = $::nzbget::log_file
    $log_dir = dirname($log_file)
  }

  if (!is_absolute_path($::nzbget::config_template)) {
    $config_template = "${::nzbget::service_dir}/${::nzbget::config_template}"
  } else {
    $config_template = $::nzbget::config_template
  }

  if ($::nzbget::required_dir) {
    $required_dir = $::nzbget::required_dir.map |$dir| {
      if (!is_absolute_path($dir)) {
        $required_abs_path = "${::nzbget::service_dir}/${dir}"
      } else {
        $required_abs_path = $dir
      }
    }
  } else {
    $required_dir = undef
  }

  if ($::nzbget::cert_store) {
    if (!is_absolute_path($::nzbget::cert_store)) {
      $cert_store = "${::nzbget::service_dir}/${::nzbget::cert_store}"
      $cert_dir = dirname($cert_store)
    } else {
      $cert_store = $::nzbget::cert_store
      $cert_dir = dirname($cert_store)
    }
  } else {
    $cert_store = undef
    $cert_dir = undef
  }

  if ($::nzbget::secure_cert) {
    if (!is_absolute_path($::nzbget::secure_cert)) {
      fail "secure_cert must be an absolute path [${::nzbget::secure_cert}]"
    } else {
      $secure_cert_dir = dirname($::nzbget::secure_cert)
      $secure_cert_file = basename($::nzbget::secure_cert)
    }
  } else {
    $secure_cert_dir = undef
    $secure_cert_file = undef
  }

  if ($::nzbget::secure_key) {
    if (!is_absolute_path($::nzbget::secure_key)) {
      fail "secure_key must be an absolute path [${::nzbget::secure_key}]"
    } else {
      $secure_key_dir = dirname($::nzbget::secure_key)
      $secure_key_file = basename($::nzbget::secure_key)
    }
  } else {
    $secure_key_dir = undef
    $secure_key_file = undef
  }

  if ($::nzbget::unpack_pass_file) {
    if (!is_absolute_path($::nzbget::unpack_pass_file)) {
      $unpack_pass_file = "${::nzbget::service_dir}/${::nzbget::unpack_pass_file}"
      $unpack_pass_dir = dirname($unpack_pass_file)
      $unpack_pass_file_name = basename($unpack_pass_file)
    } else {
      $unpack_pass_file = $::nzbget::unpack_pass_file
      $unpack_pass_dir = dirname($unpack_pass_file)
      $unpack_pass_file_name = basename($unpack_pass_file)
    }
  } else {
    $unpack_pass_file = undef
    $unpack_pass_dir = undef
    $unpack_pass_file_name = undef
  }

  $daemon_required_mounts = delete(unique([
    $::nzbget::service_dir,
    $main_dir,
    $config_file_dir,
    $nzb_dir,
    $queue_dir,
    $temp_dir,
    $cert_dir,
    $secure_cert_dir,
    $secure_key_dir,
    $web_dir] +
    $required_dir), '')

  $required_dir_config_mounts = delete(unique([
    $::nzbget::service_dir,
    $main_dir,
    $intermediate_dir,
    $destination_dir,
    $nzb_dir,
    $queue_dir,
    $temp_dir,
    $lock_dir,
    $log_dir,
    $cert_dir,
    $secure_cert_dir,
    $secure_key_dir,
    $unpack_pass_dir,
    $web_dir] +
    $required_dir +
    $script_dir), '')

  $managed_service_dirs = nzb_dir_filter(
    [$::nzbget::service_dir, $main_dir] + $script_dir,
    $masks)

  $_managed_data_dirs = nzb_dir_filter(
    [$intermediate_dir,
      $destination_dir,
      $nzb_dir,
      $queue_dir,
      $temp_dir],
    $masks)

  # If both are managed, remove any service dupes from data dirs.
  if ($::nzbget::manage_service_dirs[0] and $::nzbget::manage_data_dirs[0]) {
    $managed_data_dirs = delete($_managed_data_dirs, $managed_service_dirs)
  } else {
    $managed_data_dirs = $_managed_data_dirs
  }

  case $::nzbget::group {
    $::nzbget::user: { $user_resource_group = undef }
    default:         { $user_resource_group = $::nzbget::group }
  }
}
