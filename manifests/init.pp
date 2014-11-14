# == class: puppet-cic-install
#
# == Parameters
#

class inin-cic-install(
  $ensure	= installed,
)
{

  $downloads = "C:/Downloads"

  if ($operatingsystem != 'Windows')
  {
    err("This module works on Windows only!")
    fail("Unsupported OS")
  }
  
  case $ensure
  {
    installed:
    {
    
      # ==================
      # -= Requirements =-
      # ==================

      notice("Ensuring .Net 3.5 is enabled")
      dism { 'NetFx3':
        ensure => present,
        all => true,
      }
      
      # ================
      # -= CIC Server =-
      # ================

      notice("Downloading CIC Server")
      $cicserver_source = '\\\\192.168.0.22\\Logiciels\\ININ\\2015R1\\CIC_2015_R1\\Installs\\ServerComponents\\ICServer_2015_R1.msi'
      $cicserver_install = 'ICServer_2015_R1.msi'

      exec {"cicserver-install-download":
        command  => "((new-object net.webclient).DownloadFile('${cicserver_source}','${downloads}/${cicserver_install}'))",
        creates  => "${downloads}/${cicserver_install}",
        provider => powershell,
        require  => [
          File["${downloads}"],
          ],
      }
      
      notice("Installing CIC Server")
      exec {"cicserver-install-run":
        command  => "msiexec /i \${downloads}/\${cicserver_install} PROMPTEDUSER=\$env:username PROMPTEDDOMAIN=\$env:userdomain PROMPTEDPASSWORD=\"vagrant\" INTERACTIVEINTELLIGENCE='C:\\I3\\IC' TRACING_LOGS='C:\\I3\\IC\\Logs' STARTEDBYEXEORIUPDATE=1 CANCELBIG4COPY=1 OVERRIDEKBREQUIREMENT=1 REBOOT=ReallySuppress /l*v icserver.log /qb! /norestart",
        creates  => "C:/I3/IC/Server/NotifierU.exe",
        cwd      => "${downloads}",
        provider => windows,
        timeout  => 1800,
        require  => [
          File["${downloads}"],
          Exec['cicserver-install-download'],
          Dism['NetFx3'],
        ],
      }
      
      # ==========================
      # -= Interaction Firmware =-
      # ==========================

      notice("Downloading Interaction Firmware")
      $interactionfirmware_source = '\\\\192.168.0.22\\Logiciels\\ININ\\2015R1\\CIC_2015_R1\\Installs\\ServerComponents\\InteractionFirwmare_2015_R1.msi'
      $interactionfirmware_install = 'InteractionFirwmare_2015_R1.msi'

      exec {"interactionfirmware-install-download":
        command  => "((new-object net.webclient).DownloadFile('${interactionfirmware_source}','${downloads}/${interactionfirmware_install}'))",
        creates  => "${downloads}/${interactionfirmware_install}",
        provider => powershell,
        require  => [
          File["${downloads}"],
          Exec['cicserver-install-run'],
          ],
      }

      notice("Installing Interaction Firmware")
      exec {"interactionfirmware-install-run":
        command  => "msiexec /i ${downloads}/${interactionfirmware_install} STARTEDBYEXEORIUPDATE=1 REBOOT=ReallySuppress /l*v interactionfirmware.log /qb! /norestart",
        creates  => "C:/I3/IC/Server/Firmware/.firmware???",
        cwd      => "${downloads}",
        provider => windows,
        timeout  => 1800,
        require  => [
          File["${downloads}"],
          Exec['interactionfirmware-install-download'],
          Dism['NetFx3'],
        ],
      }
      
      # =================
      # -= CIC License =-
      # =================

      notice("Getting Host Id...")
      file {'C:\\gethostid.ahk':
        ensure    => file,
        content   => template('inin-cic-install/gethostid.ahk.erb'),
      }
      
      exec {"gethostid-run":
        command => "cmd.exe /c C:\\gethostid.ahk",
        path    => $::path,
        require => File["C:\\gethostid.ahk"],
      }

      notice("Generating CIC License...")
      file {'C:\\generateciclicense.ahk':
        ensure  => file,
        require => Exec['gethostid-run'],
        content => template('inin-cic-install/generateciclicense.ahk.erb'),
      }

      exec {"generateciclicense-run":
        command => "cmd.exe /c C:\\gethostid.ahk",
        path    => $::path,
        require => [
          Exec['gethostid-run'],
          File["C:\\generateciclicense.ahk"],
        ],
      }

      # =====================
      # -= Setup Assistant =-
      # =====================

      notice("Running Setup Assistant...")
      file {'C:\\setupassistant.ahk':
        ensure  => file,
        require => [
          Exec['generateciclicense-run'],
          Exec['interactionfirmware-install-run'],
        ],
        content => template('inin-cic-install/setupassistant.ahk.erb'),
      }
      
      exec {"setupassistant-run":
        command => "cmd.exe /c C:\\setupassistant.ahk",
        path    => $::path,
      }
      
      # ==================
      # -= Media Server =-
      # ==================

      notice("Downloading Media Server")
      $mediaserver_source = '\\\\192.168.0.22\\Logiciels\\ININ\\2015R1\\CIC_2015_R1\\Installs\\Off-ServerComponents\\MediaServer_2015_R1.msi'
      $mediaserver_install = 'MediaServer_2015_R1.msi'

      exec {"mediaserver-install-download":
        command  => "((new-object net.webclient).DownloadFile('${mediaserver_source}','${downloads}/${mediaserver_install}'))",
        creates  => "${downloads}/${mediaserver_install}",
        provider => powershell,
        require  => [
          File["${downloads}"],
          Exec['setupassistant-run'],
          ],
      }

      notice("Installing Media Server")
      exec {"mediaserver-install-run":
        command  => "msiexec /i ${downloads}/${mediaserver_install} MEDIASERVER_ADMINPASSWORD_ENCRYPTED='CA1E4FED70D14679362C37DF14F7C88A' /l*v mediaserver.log /qb! /norestart",
        creates  => "C:/I3/IC/Server/mediaprovider_w32r_2_0.dll",
        cwd      => "${downloads}",
        provider => windows,
        timeout  => 1800,
        require  => [
          File["${downloads}"],
          Exec['mediaserver-install-download'],
          Dism['NetFx3'],
        ],
      }
      
      notice("Setting web config login password")
      registry::value { 'Media Server web config password':
        key     => 'HKLM\Software\WOW6432Node\Interactive Intelligence\MediaServer\WebConfigLoginPassword',
        type    => string,
        data    => 'CA1E4FED70D14679362C37DF14F7C88A',
        ensure  => present,
        require => [
          Exec['mediaserver-install-run'],
        ],
      }
      
      notice("Install Media Server license")
      #TODO GENERATE LICENSE FOR MEDIA SERVER
      
      $mediaserver_licensefile = "C:\\Users\\Vagrant\\Desktop\\MediaServerLicense.i3lic"
      registry::value { 'Media Server License':
        key     => 'HKLM\Software\WOW6432Node\Interactive Intelligence\MediaServer\LicenseFile',
        type    => string,
        data    => $mediaserver_licensefile,
        ensure  => present,
        require => [
          Exec['mediaserver-install-run'],
        ],
      }
      
      notice("Starting Media Server")
      service { 'ININMediaServer':
        ensure  => running,
        enable  => true,
        require => [
          Registry['Media Server License'],
        ],
      }
      
      notice("Pairing CIC and Media server")
      $server=$facts['hostname']
      $mediaserver_registrationurl = "https://${server}/config/servers/add/postback"
      $mediaserver_registrationnewdata = "NotifierHost=${server}&NotifierUserId=admin1&NotifierPassword=1234&AcceptSessions=true&PropertyCopySrc=&_Command=Add"
      
      file { "mediaserver-pairing":
        ensure  => present,
        path    => "C:\\mediaserverpairing.ps1",
        content => "
        
        [System.Net.ServicePointManager]::ServerCertificateValidationCallback = {\$true}
        \$uri = New-Object System.Uri (\$url)
        \$secpasswd = ConvertTo-SecureString \"1234\" -AsPlainText -Force
        \$mycreds = New-Object System.Management.Automation.PSCredential (\"admin\", $secpasswd)
        
        \$mediaserverPath = \"c:\\i3\\ic\\resources\\MediaServerConfig.xml\"
        \$commandServerCount = 0
        \$finishedLongWait = \$false;

        for(\$provisionCount = 0; \$provisionCount -lt 15; \$provisionCount++)
        {
            try { 
                \$r = Invoke-WebRequest -Uri \$uri.AbsoluteUri -Credential \$mycreds  -Method Post -Body \$newServerData
                
            } catch {
                \$x =  \$_.Exception.Message
                write-host \$x -ForegroundColor yellow
            }
        
            sleep 10
            [xml]\$mediaServerConfig = Get-Content \$mediaserverPath
            \$commandServers = \$mediaServerConfig.SelectSingleNode(\"//MediaServerConfig/CommandServers\")
            \$commandServerCount = \$commandServers.ChildNodes.Count -gt 0
            if(\$commandServerCount -gt 0)
            {
                write-host \"command server provisioned\"
                \$provisionCount = 100;
                break;
        
            }
        
            if(\$provisionCount -eq 14 -And !\$finishedLongWait)
            {
                \$finishedLongWait= \$true
                #still not provisioned, sleep and try some more
                write-host \"waiting 10 minutes before trying again\"
                sleep 600
                \$provisionCount = 0;
            }
        }
        
        if (\$commandServerCount -eq 0){
            write-host \"Error provisioning media server\" -ForegroundColor red 
        }
        
        write-host \"Approving certificate in CIC\"
        function ApproveCertificate(\$certPath){
          Set-ItemProperty -path \"Registry::\$certPath\" -name Status -value Allowed
        }
        
        \$certs = Get-ChildItem -Path \"hklm:\\Software\\Wow6432Node\\Interactive Intelligence\\EIC\\Directory Services\\Root\\CustomerSite\\Production\\Config Certificates\\Config Subsystems Certificates\"
        ApproveCertificate \$certs[0].name
        ApproveCertificate \$certs[1].name
        write-host \"Certificate approval done\"
        
        function CreateShortcut(\$AppLocation, \$description){
            \$WshShell = New-Object -ComObject WScript.Shell
            \$Shortcut = \$WshShell.CreateShortcut(\"\$env:USERPROFILE\\Desktop\\\$description.url\")
            \$Shortcut.TargetPath = \$AppLocation
            #\$Shortcut.Description = \$description 
            \$Shortcut.Save()
        }
        
        CreateShortcut \"http://localhost:8084\" \"Media_Server\"
        ",
        require => [
          Service['ININMediaServer'],
        ],
      }
      
      exec {"mediaserver-pair-cic":
        command  => "C:\\mediaserverpairing.ps1",
        provider => powershell,
        require  => [
          File['mediaserver-pairing'],
          Exec['cicserver-install-run'],
          ],
      }
      
      file {"C:\\mediaserverpairing.ps1":
        ensure => absent,
        require => [
          Exec['mediaserver-pair-cic'],
        ],
      }
      
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
}
