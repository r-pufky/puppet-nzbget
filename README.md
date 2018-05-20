[![Build Status](https://travis-ci.org/thejandroman/puppet-nzbget.svg)](https://travis-ci.org/thejandroman/puppet-nzbget)

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with nzbget](#setup)
    * [Default NZBGet Deployment](#default-nzbget-deployment)
    * [Realistic NZBGet Deployment](#realistic-nzbget-deployment)
    * [Setup requirements](#setup-requirements)
    * [Beginning with nzbget](#beginning-with-nzbget)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
6. [Limitations - OS compatibility, etc.](#limitations)
7. [Development - Guide for contributing to the module](#development)

## Overview

Manages NZBGet for Ubuntu, version 19.1.

## Module Description

This manages the repository setup, download, installation and complete
configuration of NZBGet for Ubuntu. Additionally this performs configuration
constraint checks, user creation and cert/pass file management for repeatable
deployments. Default options mirror Ubuntu's defaults.

This currently handles both systemd and upstart depending on the puppet
supported version of Ubuntu installed.

Note: This supports the 19.1 stable release. The 20.0+ release has forthcoming
config file changes that are not backwards compatabile.

## Setup

1. Install module.
2. Copy your secure_cert, secure_key and password_file if being managed  by this
   module to `modules/nzbget/files/`.
3. Add the nzbget class to any manifest requiring NZBGet. By default, the
   puppet module mirrors the Ubuntu defaults for NZBGet.

### Default NZBGet Deployment
This will configuration transmission with the default ubuntu settings, with a
custom server, disabling RSS feeds and scheduled tasks.

```puppet
class { 'nzbget':
  servers              => [{
    active             => true,
    name               => 'my server',
    level              => 0,
    optional           => false,
    group              => 1,
    host               => 'my.newsserver.examplea.com',
    port               => 443,
    username           => 'user',
    password           => 'pass',
    join_group         => false,
    encryption         => true,
    connections        => 20,
    retention          => 0,
    ip_version         => 'auto',
    }],
  feeds                => undef,
  tasks                => undef,
}
```

### Realistic NZBGet Deployment
A real deployment is going to want to customize almost anything. Here's an
example of a custom NZBGet setup, including multiple servers, categories, feeds,
and tasks. This shows all of the NZBGet options being used.

```puppet
class { 'nzbget':
  # Puppet settings
  manage_ppa           => true,
  manage_user          => true,
  manage_service_dirs  => [true, '/services'],
  manage_data_dirs     => [true, '/data/downloads'],
  manage_certs         => true,
  manage_pass_file     => true,
  user                 => 'nzbget',
  group                => 'media',
  service_dir          => '/services/nzbget',
  config_file          => '/etc/nzbget.conf',
  service_enable       => true,
  service_ensure       => true,

  # Paths Section
  main_dir             => '/services/nzbget',
  destination_dir      => '/data/downloads/complete',
  intermediate_dir     => '/data/downloads/incomplete',
  nzb_dir              => '/data/downloads/watched',
  queue_dir            => 'queue',
  temp_dir             => 'tmp',
  web_dir              => '/usr/share/nzbget/webui',
  script_dir           => ['scripts'],
  lock_file            => 'nzbget.lock',
  log_file             => '/var/log/nzbget.log',
  required_dir         => ['/data'],
  cert_store           => '/etc/certs',

  # Servers Section
  servers              => [{
    active      => true,
    name        => 'my.newsserver.com',
    level       => 0,
    optional    => false,
    group       => 0,
    host        => 'my.newsserver.com',
    port        => 119,
    username    => 'user',
    password    => 'pass',
    join_group  => false,
    encryption  => true,
    cipher      => ['+RSA', '+VERS-TLS-ALL', '+ARCFOUR-128'],
    connections => 4,
    retention   => 0,
    ip_version  => 'auto',
    notes       => 'My awesome newserver',
    }, {
    active      => true,
    name        => 'my.other.newsserver.com',
    level       => 1,
    optional    => false,
    group       => 0,
    host        => 'my.other.newsserver.com',
    port        => 119,
    username    => 'user',
    password    => 'pass',
    join_group  => false,
    encryption  => false,
    connections => 4,
    retention   => 0,
    ip_version  => 'auto',
    notes       => 'My other awesome newserver',
    }],

  # Security Section
  control_ip           => '127.0.0.1',
  control_port         => 6789,
  control_username     => 'nzbget',
  control_password     => 'tegbzn6789',
  restricted_username  => 'media-manager',
  restricted_password  => 'pass',
  add_username         => 'api-account',
  add_password         => 'pass',
  form_auth            => false,
  secure_control       => true,
  secure_port          => 9999,
  secure_cert          => '/data/services/nzbget/nzbget.crt',
  secure_key           => '/data/services/nzbget/nzbget.key',
  authorized_ips       => ['192.168.1.2', '192.168.1.3'],
  cert_check           => true,
  daemon_username      => 'root',
  umask                => '0007',

  # Categories Section
  categories           => [{
    name         => 'TV',
    dest_dir     => 'tv',
    unpack       => true,
    extensions   => ['VideoSort'],
    aliases      => ['TV - HD', 'TV*'],
    }, {
    name         => 'Documentaries',
    unpack       => true,
    }],

  # RSS Feeds Section
  feeds                => [{
    name         => 'my feed',
    url          => 'http://nzbget.net/rss',
    filter       => ['age:>2h', 'category:*hd*'],
    interval     => 15,
    backlog      => true,
    pause_nzb    => true,
    category     => 'TV',
    priority     => 0,
    extensions   => ['VideoSort'],
    }, {
    name         => 'my other feed',
    url          => 'http://nzbget.net/rss2',
    interval     => 60,
    backlog      => false,
    pause_nzb    => false,
    priority     => 0,
    }],

  # Incoming NZB's Section
  append_category_dir  => false,
  nzb_dir_interval     => 10,
  nzb_dir_file_age     => 30,
  dupe_check           => false,

  # Download Queue Section
  save_queue           => true,
  flush_queue          => true,
  reload_queue         => true,
  continue_partial     => true,
  propagation_delay    => 5,
  decode               => true,
  article_cache        => 2000,
  direct_write         => true,
  write_buffer         => 1024,
  crc_check            => true,
  file_naming          => 'auto',
  reorder_files        => true,
  post_strategy        => 'aggressive',
  disk_space           => 250,
  nzb_cleanup_disk     => true,
  keep_history         => 1,
  feed_history         => 1,

  # Connection Section
  article_retries      => 3,
  article_interval     => 10,
  article_timeout      => 60,
  url_retries          => 3,
  url_interval         => 10,
  url_timeout          => 60,
  terminate_timeout    => 600,
  download_rate        => 0,
  accurate_rate        => true,
  url_connections      => 20,
  url_force            => false,
  monthly_quota        => 0,
  quota_start_day      => 1,
  daily_quota          => 0,

  # Logging Section
  write_log            => 'rotate',
  rotate_log           => 7,
  error_target         => 'both',
  warning_target       => 'both',
  info_target          => 'both',
  detail_target        => 'log',
  debug_target         => 'log',
  log_buffer_size      => 1000,
  nzb_log              => true,
  broken_log           => true,
  crash_trace          => false,
  crash_dump           => false,
  time_correction      => 0,

  # Display Section
  output_mode          => 'curses',
  curses_nzb_name      => true,
  curses_group         => true,
  curses_time          => true,
  update_interval      => 200,

  # Scheduler Section
  tasks                => [{
    time         => ['08:00', '12:00'],
    week_days    => ['1-5', '7'],
    command      => 'DownloadRate',
    param        => '1000',
    }, {
    time         => ['16:00', '22:00'],
    week_days    => ['1', '3', '5', '7'],
    command      => 'PauseDownload',
    }],

  # Check and Repair Section
  par_check            => 'auto',
  par_repair           => true,
  par_scan             => 'full',
  par_quick            => true,
  par_buffer           => 256,
  par_threads          => 4,
  par_ignore_ext       => ['.sfv', '.nzb', '.nfo', '.ini', '.bat'],
  par_rename           => true,
  rar_rename           => true,
  direct_rename        => true,
  health_check         => 'none',
  par_time_limit       => 0,
  par_pause_queue      => false,

  # Unpack Section
  unpack               => true,
  direct_unpack        => false,
  unpack_pause_queue   => false,
  unpack_cleanup_disk  => true,
  unrar_cmd            => 'unrar',
  seven_zip_cmd        => '7z',
  ext_cleanup_disk     => ['.par2', '.sfv', '_brokenlog.txt', '.md5'],
  unpack_ignore_ext    => ['.cbr'],
  unpack_pass_file     => 'my_awesome_password_file.txt',

  # Extension Scripts
  extensions           => ['VideoSort', 'DocuSort'],
  script_order         => ['DocuSort', 'VideoSort'],
  script_pause_queue   => true,
  shell_override       => ['.py=/usr/bin/python2', '.py3=/usr/bin/python3'],
  event_interval       => 0,
}
```

### What nzbget affects

Packages affected:
* ppa:modriscoll/nzbget
* unrar
* par2
* parchive

Warnings:

If enabling managed directories, these directories will be created and owned by
the nzbget service user. This may or may not be what you want. Disable this if
you want to manage your own directory structure, but ensure the user specified
has access to these directories/files.

### Setup Requirements

* puppetlabs-apt
* puppetlabs-stdlib
* puppetlabs-concat
* pltraining-dirtree

### Beginning with nzbget

See [Setup](#setup) for complete new setup example.

See [Usage](#usage) for class parameter descriptions. Details for these options
in NZBGet can be found in [nzbget.conf][1]; convert __lower_with_under__
parameters to __CamelCase__ when searching.

#### Upgrading NZBGet puppet module

This module no longer manually builds/installs NZBGet via wget; so any existing
install will have to deal with removing that version and moving to the package
version. All other changes should not affect install, as they are just complete
config file management and constriant enforcement.

## Usage

#### Public classes

`nzbget`

## Reference

All interaction is done via the `nzbget` class. Other under the hood files:
* manifests/params.pp -> processes class parameters and sets up user options
  for usage.
* manifests/install.pp -> installs PPA package / user account.
* manifests/config.pp -> Writes configuration to client.
* manifests/service.pp -> manages the nzbget service on client.

### Parameters

Class specific parameters are used to specify how puppet manages NZBGet. NZBGet
specific parameters mirror options within the NZBGet configuration file,
[located here][1]; which puppet-specific syntax/requirements.

All parameters are required, unless noted as *optional*. Note: Parameters have
sane Ubuntu defaults, so in generic cases no parameters are acceptable as well.

#### `manage_ppa`

Puppet will manage the PPA repo and installation for NZBGet binary. Unless you
are rolling your own build or manually installing an NZBGet package, leave this
true.

Type: `Boolean`

Default: `true`

#### `manage_user`

Puppet will manage the user that NZBGet runs under. This includes home directory
creation as well as service account management. Generally you should enable
this, unless you want to do some custom options.

Type: `Boolean`

Default: `true`

#### `manage_service_dirs`

Puppet will manage the service directories for this service to run. These
directories will be created **RECURSIVELY** if they do not exist, and owned by
nzbget::user and nzbget::group.

The path specified for service directories is an __ignore mask__ for the puppet
managed directories; that means that if you have `/home/nzbget` as the
`service_dir` and `/home` as the __ignore_mask__, this module will **only**
touch/create the `nzbget` directory. This allows you to specifically multiple
levels of directories to manage, while not overwriting/deleting perms on higher
levels. Any path defined in the ignore mask needs to exist before executing this
module.

NOTE: You still have to set service directories in the config if you don't
manage them.

Managed Directories:
  `service_dir, main_dir, script_dir`

Type: `Tuple[Boolean, String]`
  * Boolean: Should service directories be managed?
  * String: Root path to ignore when **RECURSIVELY** setting permissions.

Default: `[true, '/home']`

#### `manage_data_dirs`

Puppet will manage the directories that 'store' data from NZB's. These
directories will be created **RECURSIVELY** if they do not exist, and owned by
nzbget::user and nzbget::group. NOTE: You probably want to manage these
yourself.

The path specified for data directories is an __ignore mask__ for the puppet
managed directories; that means that if you have `/data/services/nzb/download`
as `destination_dir` and `/data/services` as the __ignore_mask__, this module
will **only** touch/create the `nzb` and `download` directories. This allows
you to specifically multiple levels of directories to manage, while not
overwriting/deleting perms on higher levels. Any path defined in the ignore mask
needs to exist before executing this module.

NOTE: You still have to set data directories in the config if you don't manage
them.

Managed Directories:
  `intermediate_dir, destination_dir, nzb_dir, queue_dir, temp_dir`

Type: `Tuple[Boolean, String]`
  * Boolean: Should data directories be managed?
  * String: Root path to ignore when **RECURSIVELY** setting permissions.

Default: `[true, '/home/nzbget']`


#### `manage_certs`

Puppet will manage the installation of [secure_cert](#secure_cert) and
[secure_key](#secure_key) if true. Disable if you want to install your own
certificates manually.

The parent directories are not explicitly managed, so if you are using managed
service and data directories, you should probably place this within one of those
directories.

Certificates should be added to `modules/nzbget/files/<cert|key>`. Puppet will
automatically search for the file from the installation path's basename.

```bash
$ ls -1 ./modules/nzbget/files
nzbget.cert
nzbget.key
```

```puppet
class { 'nzbget':
  ...
  manage_certs => true,
  secure_cert => '/home/nzbget/nzbget.cert',
  secure_key => '/home/nzbget/nzbget.key',
  ...
}
```

Type: `Boolean`

Default: `true`

#### `manage_pass_file`

Puppet will manage the installation of [unpack_pass_file](#unpack_pass_file) if
true. Disable if you want to manage/install your pass file manually; however you
should still define [unpack_pass_file](#unpack_pass_file) so that location
appears within the managed NZBGet config.

```bash
$ ls -1 ./modules/nzbget/files
my_awesome_pass_file
```

```puppet
class { 'nzbget':
  ...
  manage_pass_file => true,
  unpack_pass_file => '/etc/nzbget/my_awesome_pass_file',
  ...
}
```

Type: `Boolean`

Default: `true`

#### `user`

The user account NZBGet will be run under. Can be automatically managed.

Type: `String`

Default: `nzbget`

#### `group`

The group NZBGet will be run under. Default same as username.

Type: `String`

Default: `nzbget`

#### `service_dir`

Where NZBGet service should be run from. This is also the home directory of the
managed user, and where all the relative directories are based from. Should be
the absolute path to the service directory.

Type: `String`

Default: `/home/nzbget`

#### `config_file`

Location of NZBGet service configuration file. Relative paths will be to
[service_dir](#service_dir).

Type: `String`

Default: `/etc/nzbget.conf`

#### `service_enable`

Should puppet enable this service?

Type: `Boolean`

Default: `true`

#### `service_ensure`

Should puppet ensure this service is running?

Type: `Boolean`

Default: `true`

#### `main_dir`

The main directory NZBGet uses for operation. By default this is 'downloads' per
NZBGet default convention. [service_dir](#service_dir) is probably more
reasonable.  Relative paths will be to [service_dir](#service_dir).

Type: `String`

Default: `downloads`

#### `destination_dir`

Where downloaded files should be moved to, if distinguishing between completed
and incomplete downloads. Relative paths will be to [service_dir](#service_dir).

Type: `String`

Default: `dst`

#### `intermediate_dir`

Where intermediate files should be stored. Think of this as incomplete
downloads. Relative paths will be to [service_dir](#service_dir).

Type: Optional `String`

Default: `inter`

#### `nzb_dir`

Monitored directory for new NZB's. Relative paths will be to
[service_dir](#service_dir)`.

Type: `String`

Default: `nzb`

#### `queue_dir`

Where download queue state is stored. Relative paths will be to
[service_dir](#service_dir).

Type: `String`

Default: `queue`

#### `temp_dir`

Where service temporary files are stored. Relative paths will be to
[service_dir](#service_dir).

Type: `String`

Default: `tmp`

#### `web_dir`

Location of web interface files. Relative paths will be to
[service_dir](#service_dir).

The parent directories are not explicitly managed, so if you are using managed
service and data directories, you should probably place this within one of those
directories.

Type: Optional `String`

Default: `/usr/share/nzbget/webui`

#### `script_dir`

Array of post-processing script directories. Relative paths will be to
[service_dir](#service_dir).

Type: `Array[String]`

Default: `['scripts']`

#### `lock_file`

Lock file to use when running. Relative paths will be to
[service_dir](#service_dir).

The parent directories are not explicitly managed, so if you are using managed
service and data directories, you should probably place this within one of those
directories.

Type: Optional `String`

Default: `nzbget.lock`

#### `log_file`

Log file to use. Relative paths will be to [service_dir](#service_dir).

The parent directories are not explicitly managed, so if you are using managed
service and data directories, you should probably place this within one of those
directories.

Type: `String`

Default: `dst/nzbget.log`

#### `config_template`

Base config template to use for webUI to read option descriptions. Relative
paths will be to [service_dir](#service_dir).

Type: `String`

Default: `/usr/share/nzbget/webui`

#### `required_dir`

Array of required directories for NZBGet to start. Note: These are required
directories _IN ADDITION_ to puppet configuration. NZBGet puppet module will
automatically manage required directories based on the options specified in the
class. Relative paths will be to [service_dir](#service_dir).

Type: Optional `Array[String]`

Default: `undef`

#### `cert_store`

Location of certificate store to verify sever security certificates, either a
directory or a file. Relative paths will be to [service_dir](#service_dir).

The parent directories are not explicitly managed, so if you are using managed
service and data directories, you should probably place this within one of those
directories.

Type: Optional `String`

Default: `undef`

#### `servers`

Server definitions for NZBGet. Puppet will handle creating these entries
correctly in the config. This is a optional Array of defined structures (Hash).

```puppet
class { 'nzbget':
  ...
  servers => [{
    active      => true,
    name        => 'my.newsserver.com',
    level       => 0,
    optional    => false,
    group       => 0,
    host        => 'my.newsserver.com',
    port        => 119,
    username    => 'user',
    password    => 'pass',
    join_group  => false,
    encryption  => true,
    cipher      => ['+RSA', '+VERS-TLS-ALL', '+ARCFOUR-128'],
    connections => 4,
    retention   => 0,
    ip_version  => 'auto',
    notes       => 'My awesome newserver',
  }, {
    ... another server ...
  }],
  ...
}
```

Type: Optional `Array[Hash]`
  * `active`

    Should server be actived on startup?

    Type: `Boolean`

    Default: `true`

  * `name`

    Server name for UI and logging.

    Type: Optional `String`

    Default: `undef`

  * `level`

    Priority level of server (0-99).

    Type: `Integer`

    Default: `0`

  * `optional`

    Should this be an optional, non-reliable server?

    Type: `Boolean`

    Default: `false`

  * `group`

    Group of news server, 0 disables. (0-99).

    Type: `Integer`

    Default: `0`

  * `host`

    Host name of the news server.

    Type: `String`

    Default: `my.newsserver.com`

  * `port`

    Port to connect to (0-65535).

    Type: `Integer`

    Default: `119`

  * `username`

    Server login username.

    Type: `String`

    Default: `user`

  * `password`

    Server login password.

    Type: `String`

    Default: `pass`

  * `join_group`

    Does server require 'Join Group' command?

    Type: `Boolean`

    Default: `false`

  * `encryption`

    Does server uses TLS/SSL encryption?

    Type: `Boolean`

    Default: `false`

  * `cipher`

    Cipher to use for encrypted server connection. Puppet will automatically
    convert this list to the appropriate line for config.

    Type: Optional `Array[String]`

    Default: `undef`

  * `connections`

    Maximum number of simultaneous connections (0-999).

    Type: `Integer`

    Default: `4`

  * `retention`

    How long articles are stored on news server.

    Type: `Integer`

    Default: `0`

  * `ip_version`

    IP protocol version.

    Type: `Enum['auto', 'ipv4', 'ipv6']`

    Default: `auto`

  * `notes`

    User comments on this server.

    Types: Optional `String`

    Default: `undef`

#### `control_ip`

IP that NZBGet listens on for clients.

Type: `String`

Default: `0.0.0.0`

#### `control_port`

Port that NZBGet listens on for clients (1-65535).

Type: `Integer`

Default: `6789`

#### `control_username`

Username for client login.

Type: Optional `String`

Default: `nzbget`

#### `control_password`

Password for client login.

Type: Optional `String`

Default: `tegbzn6789`

#### `restricted_username`

Restricted username for client login.

Type: Optional `String`

Default: `undef`

#### `restricted_password`

Restricted password for client login.

Type: Optional `String`

Default: `undef`

#### `add_username`

Add username for web-services login.

Type: Optional `String`

Default: `undef`

#### `add_password`

Add password for web-services login.

Type: Optional `String`

Default: `undef`

#### `form_auth`

Should NZBGet use form auth?

Type: `Boolean`

Default: `false`

#### `secure_control`

Should NZBGet use HTTPS for webUI?

Type: `Boolean`

Default: `false`

#### `secure_port`

Port that NZBGet uses for encrypted communication (1-65535).

Type: `Integer`

Default: `6791`

#### `secure_cert`

Full path to certificate files for encrypted communication. Relative paths will
be to [service_dir](#service_dir).

The parent directories are not explicitly managed, so if you are using managed
service and data directories, you should probably place this within one of those
directories.

Type: Optional `String`

Default: `undef`

#### `secure_key`

Full path to key file for encrypted communication. Relative paths will be to
[service_dir](#service_dir).

The parent directories are not explicitly managed, so if you are using managed
service and data directories, you should probably place this within one of those
directories.

Type: Optional `String`

Default: `undef`

#### `authorized_ips`

Array of IP's that are allowed to connect without authorization. Puppet will
automatically convert this list to appropriate string for config.

Type: Optional `Array[String]`

Default: `undef`

#### `cert_check`

Should NZBGet validate TLS certificates?

Type: `Boolean`

Default: `false`

#### `daemon_username`

Username for daemon-mode. NOTE: This option has effect only if the program was
started from root-account, otherwise it is ignored and the daemon runs under
current user id.

Type: `String`

Default: `root`

#### `umask`

Umask to use for newly created files.

Type: `String`

Default: `1000`

#### `categories`

Category definitions for NZBGet. Puppet will handle creating these entries
correctly in the config. This is a optional Array of defined structures (Hash).

```puppet
class { 'nzbget':
  ...
  categories => [{
    name         => 'TV',
    dest_dir     => 'tv',
    unpack       => true,
    extensions   => ['VideoSort'],
    aliases      => ['TV - HD', 'TV*'],
  }, {
    ... another category ...
  }],
  ...
}
```

Type: Optional `Array[Hash]`
  * `name`

    Category name.

    Type: `String`

    Default: `Movies`

  * `dest_dir`

    Destination directory for this category. If empty, uses the default
    [destination_dir](#destination_dir).

    Type: Optional `String`

    Default: `undef`

  * `unpack`

    Unpack downloaded NZB files?

    Type: `Boolean`

    Default: `true`

  * `extensions`

    Array of extension scripts for this category. See [reference site][2].
    Puppet will automatically convert this list to appropriate string for
    config.

    Type: Optional `Array[String]`

    Default: `undef`

  * `aliases`

    Array of aliases for this category. This matches the specified categories
    listed here in the NZB to the category you've made. Puppet will
    automatically convert this list to appropriate string for config.

    Type: Optional `Array[String]`

    Default: `undef`

#### `feeds`

RSS Feed definitions for NZBGet. Puppet will handle creating these entries
correctly in the config. This is an optional Array of defined structures (Hash).

```puppet
class { 'nzbget':
  ...
  feeds => [{
    name         => 'my feed',
    url          => 'http://nzbget.net/rss',
    filter       => ['age:>2h', 'category:*hd*'],
    interval     => 15,
    backlog      => true,
    pause_nzb    => true,
    category     => 'TV',
    priority     => 0,
    extensions   => ['VideoSort'],
  }, {
    ... another feed ...
  }],
  ...
}
```

Type: Optional `Array[Hash]`
  * `name`

    Server name for UI and logging.

    Type: `String`

    Default: `my feed`

  * `url`

    Address of the RSS feed.

    Type: Optional `String`

    Default: `undef`

  * `filter`

    Filters unwanted items from the feed. See [reference site][3] and
    [nzbget.conf][1] for more details. Puppet will automatically convert this
    list to appropriate string for config.

    Type: Optional `Array[String]`

    Default: `undef`

  * `interval`

    How often to check for new items, in minutes.

    Type: `Integer`

    Default: `15`

  * `backlog`

    Treat all items on first fetch as backlog?

    Type: `Boolean`

    Default: `false`

  * `pause_nzb`

    Add NZB files as paused?

    Type: `Boolean`

    Default: `false`

  * `category`

    Category for added NZB files.

    Type: Optional `String`

    Default: `undef`

  * `priority`

    Priority for added NZB files (-100-MAXINT). UI handles: -100, -50, 0, 50,
    100, 900. Values 900 an above are 'forced' and will download even if NZBGet
    is paused.

    Type: `Integer`

    Default: `0`

  * `extensions`

    Array of RSS feed extensions scripts to execute. See [reference site][2].
    Puppet will automatically convert this list to appropriate string for
    config.

    Type: Optional `Array[String]`

    Default: `undef`

#### `append_category_dir`

Should NZBGet append the category name in the destination directory?

Type: `Boolean`

Default: `true`

#### `nzb_dir_interval`

How often should the [nzb_dir](#nzb_di) be checked for new files, in seconds.

Type `Integer`

Default: `5`

#### `nzb_dir_file_age`

How old should an NZB file be before it is loaded to the queue, in seconds.

Type `Integer`

Default: `60`

#### `dupe_check`

Check for duplicate NZB's?

Type: `Boolean`

Default: `true`

#### `save_queue`

Should NZBGet save the download queue to the disk?

Type: `Boolean`

Default: `true`

#### `flush_queue`

Should NZBGet immediately flush file buffers to disk for queue stat file?

Type: `Boolean`

Default: `true`

#### `reload_queue`

Should NZBGet reload the queue on start?

Type: `Boolean`

Default: `true`

#### `continue_partial`

Should NZBGet continue to download partially downloaded files?

Type: `Boolean`

Default: `true`

#### `propagation_delay`

Minimum NZB post age for NZB files, in minutes.

Type: `Integer`

Default: `0`

#### `decode`

Should NZBGet decode articles?

Type: `Boolean`

Default: `true`

#### `article_cache`

Memory limit for article cache, in megabytes. 0 disables.

Type: `Integer`

Default: `0`

#### `direct_write`

Should NZBGet write decoded articles directly into destination file?

Type: `Boolean`

Default: `true`

#### `write_buffer`

Memory limit for per article write buffer, in kilobytes. 0 disables. 1024
recommended.

Type: `Integer`

Default: `0`

#### `crc_check`

Should NZBGet CRC check downloaded and decoded articles?

Type: `Boolean`

Default: `true`

#### `file_naming`

How to name downloaded files.

Type: `Enum['auto', 'nzb', 'article']`

Default: `auto`

#### `reorder_files`

Should NZBGet re-order files within nzbs for optimal download order?

Type: `Boolean`

Default: `true`

#### `post_strategy`

Post-processing strategy.

Type: `Enum['sequential', 'balanced', 'aggressive', 'rocket']`

Default: `balanced`

#### `disk_space`

Pause NZBGet if disk space gets below this value, in megabytes.

Type: `Integer`

Default: `250`

#### `nzb_cleanup_disk`

Should NZBGet delete source NZB files when it is not needed anymore?

Type: `Boolean`

Default: `true`

#### `keep_history`

How long to keep the downloaded history of NZB files, in days. 0 disables.

Type: `Integer`

Default: `30`

#### `feed_history`

How long to keep the history of outdated feed items, in days. 0 immediate
deletion of items.

Type: `Integer`

Default: `7`

#### `article_retries`

How many retries should be attempted if a download error occurs (0-99).

Type: `Integer`

Default: `3`

#### `article_interval`

Article retry interval, in seconds.

Type: `Integer`

Default: `10`

#### `article_timeout`

Connection timeout for article downloading, in seconds.

Type: `Integer`

Default: `60`

#### `url_retries`

Number of download attempts for URL fetching (0-99).

Type: `Integer`

Default: `3`

#### `url_interval`

URL fetching retry interval, in seconds.

Type: `Integer`

Default: `10`

#### `url_timeout`

Connection timeout for URL fetching, in seconds.

Type: `Integer`

Default: `60`

#### `terminate_timeout`

Timeout until a download-thread should be killed, in seconds.

Type: `Integer`

Default: `600`

#### `download_rate`

Maximum download rate on program start, in kilobytes/second. 0 no speed
control.

Tiype: `Integer`

Default: `0`

#### `accurate_rate`

Should NZBGet do accurate speed rate calculations?

Type: `Boolean`

Default: `false`

#### `url_connections`

Maximum number of simultaneous connections for nzb URL downloads (0-999).

Tiype: `Integer`

Default: `4`

#### `url_force`

Should NZBGet Force URL-downloads even if download queue is paused?

Type: `Boolean`

Default: `true`

#### `monthly_quota`

Monthly download volume quota, in megabytes. 0 disables.

Tiype: `Integer`

Default: `0`

#### `quota_start_day`

Day of month when the monthly quota starts (1-31).

Tiype: `Integer`

Default: `1`

#### `daily_quota`

Daily download volume quota, in megabytes. 0 disables.

Tiype: `Integer`

Default: `0`

#### `write_log`

How to use log files.

Type: `Enum['none', 'append', 'reset', 'rotate']`

Default: `append`

#### `rotate_log`

Log file rotation period when [write_log](#write_log) is set to `rotate`, in
days.

Type: `Integer`

Default: `3`

#### `error_target`

How error messages must be printed.

Type: `Enum['screen', 'log', 'both', 'none']`

Default: `both`

#### `warning_target`

How warning messages must be printed.

Type: `Enum['screen', 'log', 'both', 'none']`

Default: `both`

#### `info_target`

How info messages must be printed.

Type: `Enum['screen', 'log', 'both', 'none']`

Default: `both`

#### `detail_target`

How detail messages must be printed.

Type: `Enum['screen', 'log', 'both', 'none']`

Default: `log`

#### `debug_target`

How debug messages must be printed `screen, log, both` or `none`.

Type: `Enum['screen', 'log', 'both', 'none']`

Default: `log`

#### `log_buffer_size`

Number of messages stored and available for remote clients, message number.

Type: `Integer`

Default: `1000`

#### `nzb_log`

Should NZBGet create log for each downloaded NZB file?

Type: `Boolean`

Default: `true`

#### `broken_log`

Should NZBGet create log for each downloaded NZB file?

Type: `Boolean`

Default: `true`

#### `crash_trace`

Should NZBGet print call stack trace into log on program crash?

Type: `Boolean`

Default: `true`

#### `crash_dump`

Should NZBGet save memory dump into disk on program crash?

Type: `Boolean`

Default: `false`

#### `time_correction`

Local time correction. Values in the range -24..+24 are interpreted as hours,
other values as minutes.

Type: `Integer`

Default: `0`

#### `output_mode`

Set screen-outputmode.

Type: `Enum['loggable', 'colored', 'curses']`

Default: `curses`

#### `curses_nzb_name`

Should NZBGet show NZB-Filename in file list in curses-outputmode?

Type: `Boolean`

Default: `true`

#### `curses_group`

Should NZBGet show files in groups in queue list in curses-outputmode?

Type: `Boolean`

Default: `false`

#### `curses_time`

Should NZBGet show timestamps in message list in curses-outputmode?

Type: `Boolean`

Default: `false`

#### `update_interval`

Update interval for Frontend/remote client mode, in milliseconds (25-MAXINT).

Type: `Integer`

Default: `200`

#### `tasks`

Task definitions for NZBGet. Puppet will handle creating these entries
correctly in the config. This is a optional Array of defined structures (Hash).

```puppet
class { 'nzbget':
  ...
  tasks => [{
    name         => 'my feed',
    time         => ['08:00', '12:00'],
    week_days    => ['1-5', '7'],
    command      => 'DownloadRate',
    param        => '1000',
  }, {
    ... another task ...
  }],
  ...
}
```

Type: Optional `Array[Hash]`
  * `time`

    Time to execute the command (HH:MM). An asterisk placed in the hours
    location will run task every hour (e. g. "\*:00"). An asterisk without
    minutes will run task at program startup (e. g. "\*"). Puppet will
    automatically convert this list to appropriate string for config.

    Type: Optional `Array[String]`

    Default: `undef`

  * `week_days`

    Week days to execute the command (1-7). Comma separated list of week days
    numbers. 1 is Monday. Character '-' may be used to define ranges. Puppet
    will automatically convert this list to appropriate string for config.

    Type: Optional `Array[String]`

    Default: `undef`

  * `command`

    Command to be executed.

    Type: `Enum['PauseDownload',
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
                'FetchFeed']`

    Default: `PauseDownload`

  * `param`

    Parameters for the command, if needed.

    Type: Optional `String`

    Default: `undef`

#### `par_check`

Whether and how par-verification must be performed.

Type: `Enum['auto', 'always', 'force', 'manual']`

Default: `auto`

#### `par_repair`

Should NZBGet automatically par-repair after par-verification?

Type: `Boolean`

Default: `true`

#### `par_scan`

What files should be scanned during par-verification.

Type: `Enum['limited', 'extended', 'full', 'dupe']`

Default: `extended`

#### `par_quick`

Should NZBGet do quick file verification during par-check?

Type: `Boolean`

Default: `true`

#### `par_buffer`

Memory limit for par-repair buffer, in megabytes.

Type: `Integer`

Default: `16`

#### `par_threads`

Number of threads to use during par-repair (0-99). 0 to automatically use all
cores.

Type: `Integer`

Default: `0`

#### `par_ignore_ext`

Array of file extensions/masks to ignore during par-check. Puppet will
automatically convert this list to appropriate string for config.

Type: Optional `Array[String]`

Default: `['.sfv', '.nzb', '.nfo']`

#### `par_rename`

Should NZBGet check for renamed and missing files using par-files?

Type: `Boolean`

Default: `true`

#### `rar_rename`

Should NZBGet check for renamed rar-files?

Type: `Boolean`

Default: `true`

#### `direct_rename`

Should NZBGet directly rename files during downloading?

Type: `Boolean`

Default: `false`

#### `health_check`

What to do if download health drops below critical health.

Type: `Enum['delete', 'park', 'pause', 'none']`

Default: `park`

#### `par_time_limit`

Maximum allowed time for par-repair, in minutes. 0 mean unlimited.

Type: `Integer`

Default: `0`

#### `par_pause_queue`

Should NZBGet pause download queue during check/repair?

Type: `Boolean`

Default: `false`

#### `unpack`

Should NZBGet unpack downloaded nzb-files?

Type: `Boolean`

Default: `true`

#### `direct_unpack`

Should NZBGet directly unpack files during downloading?

Type: `Boolean`

Default: `false`

#### `unpack_pause_queue`

Should NZBGet pause download queue during unpack?

Type: `Boolean`

Default: `false`

#### `unpack_cleanup_disk`

Should NZBGet delete archive files after successful unpacking?

Type: `Boolean`

Default: `true`

#### `unrar_cmd`

Full path to unrar executable. The option can also contain extra switches to
pass.

Type: `String`

Default: `unrar`

#### `seven_zip_cmd`

Full path to 7-Zip executable. The option can also contain extra switches to
pass.

Type: `String`

Default: `7z`

#### `ext_cleanup_disk`

Array of file extensions, file names or file masks to delete after successful
download. Puppet will automatically convert this list to appropriate string for
config.

Type: Optional `Array[String]`

Default: `['.par2', '.sfv', '_brokenlog.txt']`

#### `unpack_ignore_ext`

Array of file extensions to ignore when unpacking archives or renaming
obfuscated archive files. Puppet will automatically convert this list to
appropriate string for config.

Type: Optional `Array[String]`

Default: `['.cbr']`

#### `unpack_pass_file`

Path to file containing unpack passwords. Relative paths will be to
[service_dir](#service_dir).

The parent directories are not explicitly managed, so if you are using managed
service and data directories, you should probably place this within one of those
directories.

Type: Optional `String`

Default: `undef`

#### `extensions`

Array of active extension scripts for new downloads. See [reference site][2].
Puppet will automatically convert this list to appropriate string for config.

Type: Optional `Array[String]`

Default: `undef`

#### `script_order`

Array of exceutions scripts (above), in the order they should be executed.
Puppet will automatically convert this list to appropriate string for config.

Type: Optional `Array[String]`

Default: `undef`

#### `script_pause_queue`

Should NZBGet pause download queue during executing of postprocess-script?

Type: `Boolean`

Default: `false`

#### `shell_override`

Array of Shell overrides for script interpreters. A shell override consists of
file extension (starting with dot) followed by equal sign and the full path to
script interpreter. Puppet will automatically convert this list to appropriate
string for config.

Type: Optional `Array[String]`

Default: `undef`

#### `event_interval`

Minimum interval between queue events, in seconds. -1 disables.

Type: `Integer`

Default: `0`

## Limitations

Ubuntu 16.04, 14.04.

### Managed NZBGet user cannot have home / group changed after install.

Since the user has to be manually managed, instead of managed by the installed
package, there exists the following issues:

1) The service needs to be stopped before the service user can have usermod run.
2) [There's no 'puppet' way to manully stop the service for a user modifcation.][4]

There are work arounds, such as defining service/systemctl and running exec{} to
force stop the service (by requiring the exec in the user definition), however
in testing this seems to be unpredictible in execution order, leading to it
working in some cases and not working in others.

This is left out for the consumer of this to resolve. Determinisitic CL's
welcome.

## Development

Submit changes per the original license.

[1]: https://github.com/nzbget/nzbget/blob/c0eedc342b422ea2797bc85a3fb19c0a2c60e716/nzbget.conf
[2]: https://nzbget.net/extension-scripts
[3]: https://nzbget.net/rss
[4]: https://ask.puppet.com/question/20749/how-do-i-modify-a-user-who-has-a-service-running/