# == Class: glacier
#
# Installs the glacier-cmd from https://github.com/uskudnik/amazon-glacier-cmd-interface.
# Which is a command line interface to Amazon's glacier service.
#
# === Parameters
#
# [*glacier_config*]
#   The location of the glacier config file.  This should be the full path
#   including the filename.  Example: /home/joe/.glacier-cmd
#
# [*glacier_config_owner*]
#   The user who will own the config file.  The user must already exist.
#
# [*glacier_config_group*]
#   The group who will own the config file.  The group must already exist.
#
# [*aws_access_key*]
#   The AWS access key.
#
# [*aws_secret_key*]
#   The AWS secret.
#
# [*aws_region*]
#   The AWS region you want to put your data in.
#
# [*sdb_access_key*]
#   The AWS SDB access key.
#
# [*sdb_secret_key*]
#   The AWS SDB secret.
#
# [*bookkeeping*]
#
#
# [*bookkeeping_domain*]
#
#
# [*logfile*]
#
#
# [*loglevel*]
#
#
# [*output*]
#
# === Examples
#
#  class { glacier:
#    aws_access_key => '11223344',
#    aws_secret_key => '55667788'
#  }
#
#  or
#
#  class { glacier:
#    aws_access_key       => '11223344',
#    aws_secret_key       => '55667788',
#    glacier_config       => '/home/joe/.glacier-cmd',
#    glacier_config_owner => 'joe',
#    glacier_config_group => 'joe'
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
