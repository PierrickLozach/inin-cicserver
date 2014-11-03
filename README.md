puppet-cic-install
==================

This module installs CIC silently.

## Usage

Example:
```puppet
class {'cic':
}
```

See http://www.inin.com for more information about Interactive Intelligence products.

## MSI Properties

PROMPTEDUSER: Logged-on Username
PROMPTEDDOMAIN: Logged-on User Domain
PROMPTEDPASSWORD: Logged-on User Password
ENCRYPTED_PROMPTEDPASSWORD: Encrypted Logged-on User Password
INTERACTIVEINTELLIGENCE: Base install directory. <systemdrive>\Program Files\Interactive Intelligence
TRACING_LOGPATH: Logging directory. <systemDrive>\temp\inin_tracing
