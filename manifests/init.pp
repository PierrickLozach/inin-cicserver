# == class: puppet-cic-install
#
# == Parameters
#
# == Authors
#
# Pierrick Lozach
#

class puppet-cic-install {

  if ($operatingsystem != 'Windows')
  {
    err("This module works on Windows only!")
    fail("Unsupported OS")
  }
  
  validate_re($edition, ['^(?i)(express|standard|enterprise)$'])
  validate_re($license_type, ['^(?i)(evaluation|MSDN|Volume|Retail)$'])
  
  case $ensure
  {
    installed:
    {
    
      notice("Ensuring .Net 3.5 is enabled")
      dism { 'NetFx3':
        ensure => present,
        all => true,
      }
      
      notice("Downloading CIC Server")
      $cicserver_source = '\\\\192.168.0.22\\Logiciels\\ININ\\2015R1\\CIC_2015_R1\\Installs\\ServerComponents\\ICServer_2015_R1.msi'
      $cicserver_install = url_parse($cicserver_source, 'filename')

      exec {"cicserver-install-download":
        command  => "((new-object net.webclient).DownloadFile('${cicserver_source}','${core::cache_dir}/${cicserver_install}'))",
        creates  => "${core::cache_dir}/${cicserver_install}",
        provider => powershell,
        require  => [
          File["${core::cache_dir}"],
          ],
      }
      
      notice("Installing CIC Server")
      exec {"cicserver-install-run":
        command  => "msiexec /i ${core::cache_dir}/${cicserver_install} PROMPTEDUSER=$env:username PROMPTEDDOMAIN=$env:userdomain PROMPTEDPASSWORD=\"vagrant\" INTERACTIVEINTELLIGENCE='C:\I3\IC' TRACING_LOGS='C:\I3\IC\Logs' STARTEDBYEXEORIUPDATE=1 CANCELBIG4COPY=1 OVERRIDEKBREQUIREMENT=1 REBOOT=ReallySuppress /l*v icserver.log /qb! /norestart",
        creates  => "C:/I3/IC/Server/NotifierU.exe",
        cwd      => "${core::cache_dir}",
        provider => windows,
        timeout  => 1800,
        require  => [
          File["${core::cache_dir}"],
          Exec['cicserver-install-download'],
          Dism['NetFx3'],
        ],
      }
      
      notice("Downloading Interaction Firmware")
      $interactionfirmware_source = '\\\\192.168.0.22\\Logiciels\\ININ\\2015R1\\CIC_2015_R1\\Installs\\ServerComponents\\InteractionFirwmare_2015_R1.msi'
      $interactionfirmware_install = url_parse($interactionfirmware_source, 'filename')

      exec {"interactionfirmware-install-download":
        command  => "((new-object net.webclient).DownloadFile('${interactionfirmware_source}','${core::cache_dir}/${interactionfirmware_install}'))",
        creates  => "${core::cache_dir}/${interactionfirmware_install}",
        provider => powershell,
        require  => [
          File["${core::cache_dir}"],
          Exec['cicserver-install-run'],
          ],
      }

      notice("Installing Interaction Firmware")
      exec {"interactionfirmware-install-run":
        command  => "msiexec /i ${core::cache_dir}/${interactionfirmware_install} STARTEDBYEXEORIUPDATE=1 REBOOT=ReallySuppress /l*v interactionfirmware.log /qb! /norestart",
        creates  => "C:/I3/IC/Server/Firmware/.firmware???",
        cwd      => "${core::cache_dir}",
        provider => windows,
        timeout  => 1800,
        require  => [
          File["${core::cache_dir}"],
          Exec['interactionfirmware-install-download'],
          Dism['NetFx3'],
        ],
      }
      
      notice("Downloading Media Server")
      $mediaserver_source = '\\\\192.168.0.22\\Logiciels\\ININ\\2015R1\\CIC_2015_R1\\Installs\\Off-ServerComponents\\MediaServer_2015_R1.msi'
      $mediaserver_install = url_parse($mediaserver_source, 'filename')

      exec {"mediaserver-install-download":
        command  => "((new-object net.webclient).DownloadFile('${mediaserver_source}','${core::cache_dir}/${mediaserver_install}'))",
        creates  => "${core::cache_dir}/${mediaserver_install}",
        provider => powershell,
        require  => [
          File["${core::cache_dir}"],
          Exec['cicserver-install-run'],
          ],
      }

      notice("Installing Media Server")
      exec {"mediaserver-install-run":
        command  => "msiexec /i ${core::cache_dir}/${mediaserver_install} MEDIASERVER_ADMINPASSWORD_ENCRYPTED='CA1E4FED70D14679362C37DF14F7C88A' /l*v mediaserver.log /qb! /norestart",
        creates  => "C:/I3/IC/Server/mediaprovider_w32r_2_0.dll",
        cwd      => "${core::cache_dir}",
        provider => windows,
        timeout  => 1800,
        require  => [
          File["${core::cache_dir}"],
          Exec['mediaserver-install-download'],
          Dism['NetFx3'],
        ],
      }
      
      notice("Setting web config login password")
      
      
    }
    uninstalled:
    {
      notice('Uninstalling CIC server')
    }
    default:
    {
      fail("Unsupported ensure \"${ensure}\"")
    }

}
