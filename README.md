# cicserver::install & cicserver::icsurvey

[![Build Status](https://travis-ci.org/PierrickI3/inin-cicserver.svg?branch=master)](https://travis-ci.org/PierrickI3/inin-cicserver)

[![Coverage Status](https://coveralls.io/repos/PierrickI3/inin-cicserver/badge.svg)](https://coveralls.io/r/PierrickI3/inin-cicserver)

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the modules do and why it is useful](#module-description)
3. [Setup - The basics of getting started with cicserver::install and cicserver::icsurvey](#setup)
    * [What install affects](#what-install-affects)
    * [What icsurvey affects](#what-icsurvey-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with install](#beginning-with-install)
    * [Beginning with icsurvey](#beginning-with-icsurvey)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Overview

Installs CIC, Interaction Firmware and Media Server silently.
Also contains functionality to create ICSurvey files to run the Setup Assistant manually.

## Module Description

Uses ruby to create an xml file with the options pre-populated from a template (.erb) file. Allows quick unattended configuration of CIC.

## Setup

### What install affects

* Installs CIC, Interaction Firmware and Media Server.
* Warning: not recommended for production environments.

### What icsurvey affects

* Creates an .icsurvey file.
* Warning: not recommended for production environments.

### Setup Requirements **OPTIONAL**

If your module requires anything extra before setting up (pluginsync enabled,
etc.), mention it here.

### Beginning with install

The very basic steps needed for a user to get the module up and running.

If your most recent release breaks compatibility or requires particular steps
for upgrading, you may wish to include an additional section here: Upgrading
(For an example, see http://forge.puppetlabs.com/puppetlabs/firewall).

### Beginning with icsurvey

The very basic steps needed for a user to get the module up and running.

If your most recent release breaks compatibility or requires particular steps
for upgrading, you may wish to include an additional section here: Upgrading
(For an example, see http://forge.puppetlabs.com/puppetlabs/firewall).

## Usage

```puppet
class { 'cicserver::install':
    ensure                  => installed,
    survey                  => 'C:/I3/IC/Manifest/newsurvey.icsurvey',	# Where the survey should be generated (and later on, used by the IC Setup Assistant)
    installnodomain         => true,
    organizationname        => 'demoorg',
    locationname            => 'demolocation',
    sitename                => 'demosite',
    dbreporttype            => 'db',
    dbservertype            => 'mssql',
    dbtablename             => 'I3_IC',
    dialplanlocalareacode   => '317',
    emailfbmc               => true,
    recordingspath          => 'C:/I3/IC/Recordings',
    sipnic                  => 'Ethernet',
    outboundaddress         => '3178723000',
    defaulticpassword       => '1234',
    licensefile             => 'C:/vagrant-data/cic-license.i3lic',
    loggedonuserpassword    => 'vagrant',
}
```

```puppet
class {'cicserver::icsurvey':
	path 					=> 'C:/I3/IC/manifest/newsurvey.icsurvey',
	installnodomain			=> true,				# set to true if no domain
	organizationname		=> 'organizationname',
	locationname			=> 'locationname',
	sitename				=> 'sitename',
	dbreporttype			=> 'db', 				# other types will be supported later on (i.e. access)
	dbservertype			=> 'mssql'
	dbtablename				=> 'I3_IC',
	dialplanlocalareacode	=> '317',				# only option supported so far
	emailfbmc				=> true,
	recordingspath			=> 'C:/I3/IC/Recordings',
	sipnic					=> 'Ethernet',		    # use the same name as shown in windows
	outboundaddress			=> '3178723000',
	defaulticpassword		=> '1234',				# only valid for users created by ic setup assistant
	licensefile				=> 'C:/I3/IC/iclicense.i3lic',
	loggedonuserpassword 	=> 'vagrant',
    template                => 'cicserver/DefaultSurvey.ICSurvey.erb',
}
```

```puppet
class {'cicserver::user':
  ensure           => installed,
  username         => 'testuser1', # The new CIC username
  password         => '1234',
  extension        => 8001,
  pathtoscripts    => 'C:/Users/Vagrant/Desktop/Scripts/posh-ic', # Path to the powershell scripts. You can download them here: https://github.com/PierrickI3/posh-ic
  cicadminusername => 'vagrant',   # CIC user with administrative priviledges
  cicadminpassword => '1234',
  cicserver        => 'testregfr', # your CIC server name
}
```

```puppet
class {'cicserver::workgroup':
  ensure           => installed,
  workgroupname    => 'testworkgroup1', # The name for the new CIC workgroup
  extension        => 8001,
  members          => ['testuser1', 'testuser2']
  pathtoscripts    => 'C:/Users/Vagrant/Desktop/Scripts/posh-ic', # Path to the powershell scripts. You can download them here: https://github.com/PierrickI3/posh-ic
  cicadminusername => 'vagrant',   # CIC user with administrative priviledges
  cicadminpassword => '1234',
  cicserver        => 'testregfr', # your CIC server name
}
```

```puppet
class {'cicserver::users':
  ensure           => installed,
  cicuserdata      => '{"randomidentifier":{"username":"testuser1","password":"1234","extension":"8001"}, "anotherrandomidentifier":{"username":"testuser2","password":"5678","extension":"8003"}}', # JSON data
  pathtoscripts    => 'C:/Users/Vagrant/Desktop/Scripts/posh-ic', # Path to the powershell scripts. You can download them here: https://github.com/PierrickI3/posh-ic
  cicadminusername => 'vagrant',   # CIC user with administrative priviledges
  cicadminpassword => '1234',
  cicserver        => 'testregfr', # your CIC server name
}
```

```puppet
class {'cicserver::workgroups':
  ensure           => installed,
  cicworkgroupdata => '{"randomidentifier":{"workgroupname":"testworkgroup1","extension":"6001"}, "anotherrandomidentifier":{"workgroupname":"testworkgroup2","extension":"6002"}}', # JSON data
  pathtoscripts    => 'C:/Users/Vagrant/Desktop/Scripts/posh-ic', # Path to the powershell scripts. You can download them here: https://github.com/PierrickI3/posh-ic
  cicadminusername => 'vagrant',   # CIC user with administrative priviledges
  cicadminpassword => '1234',
  cicserver        => 'testregfr', # your CIC server name
}
```

## Reference

Here, list the classes, types, providers, facts, etc contained in your module.
This section should include all of the under-the-hood workings of your module so
people know what the module is touching on their system but don't need to mess
with things. (We are working on automating this section!)

## Limitations

Only compatible with Windows
Tested with Windows 2012 R2

## Development

No specific rules. Share/Use/Participate as you wish!

## Release Notes

See http://www.inin.com for more information about Interactive Intelligence products.
