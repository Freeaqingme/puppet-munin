
define munin::host (
  $fqdn,
  $address,
  $port,
  $content = template($munin::template_host)
) {

  file { "${munin::include_dir}/${fqdn}.conf":
    ensure  => $munin::manage_file,
    path    => "${munin::include_dir}/${fqdn}.conf",
    mode    => $munin::config_file_mode,
    owner   => $munin::config_file_owner,
    group   => $munin::config_file_group,
    content => $content,
  }

  # Todo: add fw rule

}
