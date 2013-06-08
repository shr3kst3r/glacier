# == Class: glacier
#
# Installs the glacier-cmd from https://github.com/uskudnik/amazon-glacier-cmd-interface.
# Which is a command line interface to Amazon's glacier service.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if it
#   has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should not be used in preference to class parameters  as of
#   Puppet 2.6.)
#
# === Examples
#
#  class { glacier:
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ]
#  }
#
# === Authors
#
# Dennis Rowe <shr3kst3r@gmail.com>
#
# === Copyright
#
# Copyright 2013 Dennis Rowe, unless otherwise noted.
#
class glacier(
    $glacier_config       = '/etc/glacier-cmd.conf',
    $glacier_config_owner = 'root',
    $glacier_config_group = 'root',
    $aws_access_key       = 'AWSKEY',
    $aws_secret_key       = 'AWSSECRET',
    $aws_region           = 'us-west-1',
    $sdb_access_key       = 'SDBKEY',
    $sdb_secret_key       = 'SDBSECRET',
    $bookkeeping          = 'False',
    $bookkeeping_domain   = 'example.com',
    $logfile              = '/var/log/glacier-cmd.log',
    $loglevel             = 'INFO',
    $output               = 'print'
  ) {
  package { 'python-setuptools':
    ensure => installed
  }

  vcsrepo { '/opt/amazon-glacier-cmd-interface':
    ensure   => present,
    provider => git,
    source   => 'git://github.com/uskudnik/amazon-glacier-cmd-interface.git'
  }

  exec { 'install_glacier_cmd':
    command => 'python setup.py install',
    cwd     => '/opt/amazon-glacier-cmd-interface',
    path    => ['/bin', '/usr/bin'],
    require => [ Package['python-setuptools'], Vcsrepo['/opt/amazon-glacier-cmd-interface' ] ],
    creates => '/usr/bin/glacier-cmd'
  }

  file { $glacier_config:
    ensure  => present,
    owner   => $glacier_config_owner,
    group   => $glacier_config_group,
    mode    => '0644',
    content => template('glacier/glacier-cmd.conf.erb'),
    require => Exec['install_glacier_cmd']
  }
}
