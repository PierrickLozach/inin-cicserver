# == Class: cicserver::workgroups
#
# Creates workgroups using Powershell and the ICWS API
#
# === Parameters
#
# [ensure]
#   installed. Workgroup will be created. No other values are currently supported.
#
# [cicworkgroupdata]
#   Hash of CIC workgroups with the following format:
#     {'unique identifier':{'workgroupname:':'testworkgroup1','extension':'6001'}, 'also a unique id':{'workgroupname:':'testworkgroup2','extension':'6002'}}
#
# [pathtoscripts]
#   Path to the powershell scripts to communicate with the ICWS API. Scripts are available here: https://github.com/PierrickI3/posh-ic
#
# [cicadminusername]
#   CIC user with administrative priviledges to create/delete CIC workgroups.
#
# [cicadminpassword]
#   CIC Admin password.
#
# [cicserver]
#   CIC server name or IP address. Use localhost if running on the CIC server.
#
# === Examples
#
#  class {'cicserver::workgroups':
#   ensure           => installed,
#   cicworkgroupdata      => '{'asdsadg':{'workgroupname:':'testworkgroup1','extension':'6001'}, 'asdasdfgrf':{'workgroupname:':'testworkgroup2','extension':'6002'}}',
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

class cicserver::workgroups (
  $ensure = installed,
  $cicworkgroupdata,
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
      $cicworkgroups = convert_to_json($cicworkgroupdata)

      notify { "Creating workgroups: ${cicworkgroupdata}":}
      notify { "Creating workgroups (json): ${cicworkgroups}":}

      exec { 'create-ic-workgroups':
        command   => template('cicserver/new-workgroups.ps1.erb'),
        path      => $pathtoscripts,
        cwd       => $pathtoscripts,
        timeout   => 30,
        provider  => powershell,
        logoutput => true,
      }
    }
    absent:
    {
      debug('Deleting CIC workgroup')
    }
    default:
    {
      fail("Unsupported ensure \"${ensure}\"")
    }
  }
}
