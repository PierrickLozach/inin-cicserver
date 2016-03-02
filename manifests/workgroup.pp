# == Class: cicserver::workgroup
#
# Creates a workgroup using Powershell and the ICWS API
#
# === Parameters
#
# [ensure]
#   installed. Workgroup will be created. No other values are currently supported.
#
# [workgroupname]
#   CIC workgroup name.
#
# [extension]
#   CIC user extension.
#
# [members]
#   Workgroup members.
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
#   workgroupname    => 'testworkgroup1',
#   extension        => 8001,
#   members          => ['testuser1', 'testuser2'],
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

class cicserver::workgroup (
  $ensure = installed,
  $workgroupname,
  $extension,
  $members,
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
      exec { 'create-ic-workgroup':
        command   => template('cicserver/new-workgroup.ps1.erb'),
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
