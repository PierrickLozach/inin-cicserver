# == Class: cicserver::users
#
# Creates users using Powershell and the ICWS API
#
# === Parameters
#
# [ensure]
#   installed. User will be created. No other values are currently supported.
#
# [userdata]
#   Hash of CIC users with the following format:
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
#  class {'cicserver::users':
#   ensure           => installed,
#   userdata         => '',
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

class cicserver::users (
  $ensure = installed,
  $cicuserdata,
  $pathtoscripts = 'C:/Users/Vagrant/Desktop/Scripts/posh-ic/lib/',
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
      $cicusers = convert_to_json($cicuserdata)

      notify { "Creating users: ${cicuserdata}":}
      notify { "Creating users (json): ${cicusers}":}

      exec { 'create-ic-users':
        command   => template('cicserver/new-users.ps1.erb'),
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