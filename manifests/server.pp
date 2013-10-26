#
# Class: munin::server
#
# Installs Munin Grapher/Gatherer
#
# Usage:
# include munin::server
# Autoloads munin::server (The Munin grapher/gatherer)
# if $munin_server_local is true or $munin_server is equal to $ipaddress
#
class munin::server inherits munin {

  package { 'munin_server':
    ensure => $munin::manage_package,
    name   => $munin::package_server,
  }

  file { 'munin.conf_server':
    ensure  => $munin::manage_file,
    path    => $munin::config_file_server,
    mode    => $munin::config_file_mode,
    owner   => $munin::config_file_owner,
    group   => $munin::config_file_group,
    require => Package['munin_server'],
    content => template($munin::template_server),
    replace => $munin::manage_file_replace,
    audit   => $munin::manage_audit,
  }

  file { 'munin.include_dir_server':
    recurse => true,
    force   => true,
    purge   => true,
    ensure  => directory,
    path    => $munin::include_dir,
    mode    => '0755',
    owner   => $munin::config_file_owner,
    group   => $munin::config_file_group,
    require => Package['munin_server'],
  }

  Munin::Host <<| tag == $munin::magic_tag |>>

}
