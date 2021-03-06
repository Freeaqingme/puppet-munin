# Class: munin::params
#
# This class defines default parameters used by the main module class munin
# Operating Systems differences in names and paths are addressed here
#
# == Variables
#
# Refer to munin class for the variables defined here.
#
# == Usage
#
# This class is not intended to be used directly.
# It may be imported or inherited by other classes
#
class munin::params {

  ### Module Specific parameters
  $server = '127.0.0.1'
  $server_local = false
  $address = '*'
  $folder = ''
  $grouplogic = ''
  $extra_plugins = false
  $autoconfigure = true
  $autoconfigure_template = $::operatingsystem ? {
    'FreeBSD' => 'munin/munin-autoconfigure-freebsd.erb',
    default   => 'munin/munin-autoconfigure.erb',
  }
  $autoconfigure_cron_file = $::operatingsystem ? {
    'FreeBSD' => '/usr/local/etc/periodic/daily/munin-autoconfigure',
    default   => '/etc/cron.daily/munin-autoconfigure',
  }

  $graph_period = 'second'

  if $::fqdn {
    $fqdn = $::fqdn
  } else {
    $fqdn = $::hostname
  }

  $package_perlcidr = $::operatingsystem ? {
    /(?i:Centos|Redhat|Scientific|Amazon|Linux)/ => $::operatingsystemrelease ? {
      4        => 'perl-Net-CIDR-Lite',
      default  => 'perl-Net-CIDR',
    },
    /(?i:Solaris)/ => 'CSWpm-net-cidr',
    'FreeBSD'      => 'p5-Net-CIDR',
    default        => 'libnet-cidr-perl',
  }

  $package_server = $::operatingsystem ? {
    /(?i:Solaris)/ => 'CSWmunin-master',
    default        => 'munin',
  }

  $config_file_server = '/etc/munin/munin.conf'
  $template_server = 'munin/munin.conf.erb'
  $template_host = 'munin/host.erb'

  $include_dir = $::operatingsystem ? {
    /(?i:Solaris)/ => '/etc/opt/csw/munin/munin-conf.d',
    default        => '/etc/munin/munin-conf.d',
  }
  $include_dir_purge = false

  $conf_dir_plugins = $::operatingsystem ? {
    /(?i:Solaris)/ => '/etc/opt/csw/munin/plugin-conf.d',
    /(?i:FreeBSD)/ => '/usr/local/etc/munin/plugin-conf.d',
    default        => '/etc/munin/plugin-conf.d',
  }

  $conf_dir_active_plugins = $::operatingsystem ? {
    /(?i:Solaris)/  => '/etc/opt/csw/munin/plugins/',
    /(?i:FreeBSD)/  => '/usr/local/etc/munin/plugins/',
    default         => '/etc/munin/plugins/',
  }

  $web_dir = $::operatingsystem ? {
    /(?i:Ubuntu|Debian|Mint)/ => '/var/cache/munin/www',
    'FreeBSD'                 => '/usr/local/www/munin',
    default                   => '/var/www/html/munin',
  }

  $plugins_dir = $::operatingsystem ? {
    /(?i:Solaris)/ => '/opt/csw/libexec/munin/plugins',
    /(?i:FreeBSD)/ => '/usr/local/share/munin/plugins',
    default        => '/usr/share/munin/plugins',
  }

  $restart_or_reload = $::operatingsystem ? {
    /(?i:Debian)/ => 'restart',
    default       => 'reload',
  }

  ### Application related parameters

  $package = $::operatingsystem ? {
    /(?i:Solaris)/ => 'CSWmunin-node',
    default        => 'munin-node',
  }

  $service = $::operatingsystem ? {
    /(?i:Solaris)/ => 'application/cswmuninnode',
    default        => 'munin-node',
  }

  $service_status = $::operatingsystem ? {
    default => true,
  }

  $process = $::operatingsystem ? {
    /(?i:FreeBSD)/ => 'perl',
    /(?i:Ubuntu)/  => $::operatingsystemrelease ? {
      '12.04'  => 'munin',
      default => 'munin-node',
    },
    default => 'munin-node',
  }

  $process_args = $::operatingsystem ? {
    /(?i:FreeBSD)/ => 'munin-node',
    /(?i:Ubuntu)/  => $::operatingsystemrelease ? {
      '12.04'  => 'munin-node',
      default => '',
    },
    default => '',
  }

  $process_user = $::operatingsystem ? {
    default => 'root',
  }

  $process_group = $::operatingsystem ? {
    'FreeBSD' => 'wheel',
    default => 'root',
  }

  $config_dir = $::operatingsystem ? {
    /(?i:Solaris)/ => '/etc/opt/csw/munin',
    /(?i:FreeBSD)/  => '/usr/local/etc/munin',
    default        => '/etc/munin',
  }

  $config_file = $::operatingsystem ? {
    /(?i:Solaris)/ => '/etc/opt/csw/munin/munin-node.conf',
    /(?i:FreeBSD)/ => '/usr/local/etc/munin/munin-node.conf',
    default        => '/etc/munin/munin-node.conf',
  }

  $config_file_mode = $::operatingsystem ? {
    default => '0644',
  }

  $config_file_owner = $::operatingsystem ? {
    default => 'root',
  }

  $config_file_group = $::operatingsystem ? {
    'FreeBSD' => 'wheel',
    default => 'root',
  }

  $config_file_init = $::operatingsystem ? {
    /(?i:Debian|Ubuntu|Mint)/ => '/etc/default/munin',
    default                   => '/etc/sysconfig/munin',
  }

  $pid_file = $::operatingsystem ? {
    /(?i:Solaris)/ => '/var/opt/csw/munin/log/munin-node.pid',
    default        => '/var/run/munin/munin-node.pid',
  }

  $data_dir = $::operatingsystem ? {
    'FreeBSD' => '/usr/local/etc/munin',
    default => '/etc/munin',
  }

  $log_dir = $::operatingsystem ? {
    /(?i:Solaris)/ => '/var/opt/csw/munin/log/',
    default        => '/var/log/munin',
  }

  # Munin EPEL package has changed the path of munin-node log
  # to /var/log/munin-node/munin-node.log from version 2.0.9-3 (sigh)
  # Earlier versions logged to /var/log/munin/munin.log
  # The new default is kept here. You may override it with:
  # class { 'munin':
  #   log_file => '/var/log/munin/munin.log',
  # }
  $log_file = $::operatingsystem ? {
    /(?i:RedHat|Centos|Scientific|Fedora|Amazon|Linux)/ => '/var/log/munin-node/munin-node.log',
    /(?i:Solaris)/                                      => '/var/opt/csw/munin/log/munin-node.log',
    /(?i:FreeBSD)/                                      => '/var/log/munin/munin-node.log',
    default                                             => '/var/log/munin/munin.log',
  }

  $fcgi_runlevels = '2345'

  $fcgi_command = $::operatingsystem ? {
    /(?i:Ubuntu|Debian|Mint)/ => '/usr/bin/spawn-fcgi -n -s /var/run/munin/fcgi-graph.sock -U www-data -u www-data -g www-data /usr/lib/munin/cgi/munin-cgi-graph',
    default                   => '/usr/bin/spawn-fcgi -n -s /var/run/munin/fcgi-graph.sock -U www-data -u www-data -g www-data munin-fastcgi-graph',
  }

  $fcgi_reload_init = true

  $port = '4949'
  $protocol = 'tcp'

  # General Settings
  $my_class = ''
  $source = ''
  $source_dir = ''
  $source_dir_purge = false
  $template = 'munin/munin-node.conf.erb'
  $options = ''
  $service_autorestart = true
  $version = 'present'
  $absent = false
  $disable = false
  $disableboot = false

  ### General module variables that can have a site or per module default
  $monitor = false
  $monitor_tool = ''
  $monitor_target = $::ipaddress
  $firewall = false
  $puppi = false
  $puppi_helper = 'standard'
  $debug = false
  $audit_only = false

}
