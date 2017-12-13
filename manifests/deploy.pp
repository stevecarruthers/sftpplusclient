class sftpplusclient::deploy (

  String $proatria_dl       = 'http://download.sftpplus.com/client',
  String $major_version     = '1',
  String $minor_version     = '5',
  String $sftpplus_tar      = 'sftpplus-client-rhel6-x86-1.5.64.tar.gz',
  String $download_location = '/deployment',
  Integer $timeout          = 60,
  Boolean $verbose          = true,
  String $sftpplus_home     = '/opt/sftpplus',
  String $sftpplus_clnt_dir = 'client',
  String $sftpplus_user     = 'vagrant',
  String $sftpplus_group    = 'vagrant',
  String $sftpplus_unpacked = 'sftpplus-client-rhel6-x86-1.5.64',

){

  File {
    mode   => '0755',
    owner  => $sftpplus_user,
    group  => $sftpplus_group,
  }

  Exec {
    user   => $sftpplus_user,
    group  => $sftpplus_group,
  }

  file { $sftpplus_home:
    ensure => 'directory',
  }

  exec { 'untar_sftpplus_client':
    command => "/bin/tar -zxvf ${download_location}/${sftpplus_tar} -C ${sftpplus_home} ; touch ${download_location}/.untar_sftpplus_client.completed",
    timeout => $timeout,
    creates => "${download_location}/.untar_sftpplus_client.completed",
    require => [ File[ $sftpplus_home ], Class[ 'sftpplusclient::download' ] ],
  }
  ->
  exec { 'rename_client_dir':
    command => "/bin/mv ${sftpplus_home}/${sftpplus_unpacked} ${sftpplus_home}/client",
    creates => "${sftpplus_home}/client",
  }
  ->
  file { "${sftpplus_home}/${sftpplus_unpacked}/":
    ensure => 'absent',
  }

}

