# cicserver

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with icsurvey](#setup)
    * [What icsurvey affects](#what-icsurvey-affects)
    * [Setup requirements](#setup-requirements)
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

### What icsurvey affects

* Creates an .icsurvey file.
* Warning: not recommended for production environments.

### Setup Requirements **OPTIONAL**

If your module requires anything extra before setting up (pluginsync enabled,
etc.), mention it here.

### Beginning with icsurvey

The very basic steps needed for a user to get the module up and running.

If your most recent release breaks compatibility or requires particular steps
for upgrading, you may wish to include an additional section here: Upgrading
(For an example, see http://forge.puppetlabs.com/puppetlabs/firewall).

## Usage

```puppet
class {'cicserver':
	ensure => installed,
}
```

```puppet
class {'cicserver::icsurvey':
	path 					=> 'c:/i3/ic/manifest/newsurvey.icsurvey',
	installnodomain			=> true,				# set to true if no domain
	organizationname		=> 'organizationname',
	locationname			=> 'locationname',
	sitename				=> 'sitename',
	dbreporttype			=> 'db', 				# other types will be supported later on (i.e. access)
	dbservertype			=> 'mssql'
	dbtablename				=> 'I3_IC',
	dialplanlocalareacode	=> '317',				# only option supported so far
	emailfbmc				=> true,
	recordingspath			=> "c:\\I3\\IC\\Recordings",
	sipnic					=> 'Ethernet 2',		# use the same name as shown in windows
	outboundaddress			=> '3178723000',
	defaulticpassword		=> '1234',				# only valid for users created by ic setup assistant
	licensefile				=> "c:\\i3\\ic\\iclicense.i3lic",
	hostid					=> '6300270E26DF',
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