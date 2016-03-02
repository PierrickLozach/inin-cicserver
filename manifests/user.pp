# == Class: cicserver::user
#
# Creates a user using Powershell and the ICWS API
#
# === Parameters
#
# [ensure]
#   installed. User will be created. No other values are currently supported.
#
# [username]
#   CIC username.
#
# [password]
#   CIC password.
#
# [extension]
#   CIC user extension.
#
# [pathtoscripts]
#   Path to the powershell scripts to communicate with the ICWS API. Scripts are available here: https://github.com/PierrickI3/posh-ic
#
# [cicadminusername]
#   CIC user with administrative priviledges to create/delete CIC users.
#
# [cicadminpassword]
#   CIC Admin password.
#
# [cicserver]
#   CIC server name or IP address. Use localhost if running on the CIC server.
#
# === Examples
#
#  class {'cicserver::user':
#   ensure           => installed,
#   username         => 'testuser1',
#   password         => '1234',
#   extension        => 8001,
#   pathtoscripts    => 'C:/Users/Vagrant/Desktop/Scripts/posh-ic/',
#   cicadminusername => 'vagrant',
#   cicadminpassword => 'vagrant',
#   cicserver        => 'localhost',
#  }
#
# === Authors
#
# Pierrick Lozach <pierrick.lozach@inin.com>
#
# === Copyright
#
# Copyright 2015, Interactive Intelligence Inc.
#

class cicserver::user (
  $ensure = installed,
  $username,
  $password = '1234',
  $extension,
  $pathtoscripts = 'C:/Users/Vagrant/Desktop/Scripts/posh-ic/',
  $cicadminusername,
  $cicadminpassword,
  $cicserver = 'localhost',
)
{

  if ($::operatingsystem != 'Windows')
  {
    err('This module works on Windows only!')
    fail('Unsupported OS')
  }

  case $ensure
  {
    installed:
    {
      exec { 'create-ic-user':
        command   => template('cicserver/new-user.ps1.erb'),
        path      => $pathtoscripts,
        cwd       => $pathtoscripts,
        timeout   => 30,
        provider  => powershell,
        logoutput => true,
      }
    }
    absent:
    {
      debug('Deleting CIC user')
    }
    default:
    {
      fail("Unsupported ensure \"${ensure}\"")
    }
  }
}
