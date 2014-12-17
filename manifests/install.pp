# == Class: cicserver::install
#
# Installs CIC and other ININ products silently.
#
# === Parameters
#
# [ensure]
#   installed. No other values are currently supported.
#
# [media]
#   location of the ININ MSI files. Should contain the Installs directory.
#
# [username]
#   Optional. Username to access the media share specified previously.
#
# [password]
#   Optional. Password to access the media share specified previously.
#
# [organization]
#   Interaction Center Organization Name.
#
# [location]
#   Interaction Center location name.
#
# [site]
#   Interaction Center Site Name.
#
# [dbreporttype]
#   Database report type. Only 'db' is supported for now.
#
# [dbservertype]
#   Database server type. Only 'mssql' is supported for now.
#
# [dbtablename]
#   Database table name. Defaults to I3_IC.
#
# [dialplanlocalareacode]
#   local area code. Defaults to 317.
#
# [emailfbmc]
#   Set to true to enable IC's FBMC (File Based Mail Connector). Defaults to false.
#
# [recordingspath]
#   Path to store the compressed recordings. Defaults to C:/I3/IC/Recordings.
#
# [sipnic]
#   Name of the network card (NIC) to use for SIP/RTP transport. Defaults to Ethernet.
#
# [outboundaddress]
#   Phone number to show for outbound calls. Defaults to 3178723000.
#
# [defaulticpassword]
#   Default IC user password. Defaults to 1234.
#
# [licensefile]
#   Path to the .i3lic file
#
# [mediaserverlicensefile]
#   Path to the media server license file (.i3lic)
#
# [hostid]
#   Host id to use with the license file
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if
#   it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)
#
# === Examples
#
#  class {'cicserver::install':
#   ensure                  => installed,
#   media                   => '\\\\servername\\path_to_installs_folder',
#   username                => '',
#   password                => '',
#   survey                  => 'c:/i3/ic/manifest/newsurvey.icsurvey',
#   installnodomain         => true,      
#   organizationname        => 'organizationname',
#   locationname            => 'locationname',
#   sitename                => 'sitename',
#   dbreporttype            => 'db',     
#   dbservertype            => 'mssql', 
#   dbtablename             => 'I3_IC',
#   dialplanlocalareacode   => '317',     
#   emailfbmc               => true,
#   recordingspath          => "C:\\I3\\IC\\Recordings",
#   sipnic                  => 'Ethernet',
#   outboundaddress         => '3178723000',
#   defaulticpassword       => '1234',    
#   licensefile             => "c:\\i3\\ic\\license.i3lic",
#   mediaserverlicensefile  => "c:\\i3\\ic\\mediaserverlicense.i3lic",
#   hostid                  => '6300270E26DF',
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

class cicserver::install (
  $ensure = installed,
  $media,
  $username,
  $password,
  $survey,
  $installnodomain,
  $organizationname,
  $locationname,
  $sitename,
  $dbreporttype,
  $dbservertype,
  $dbtablename,
  $dialplanlocalareacode,
  $emailfbmc,
  $recordingspath,
  $sipnic,
  $outboundaddress,
  $defaulticpassword,
  $licensefile,
  $mediaserverlicensefile,
  $hostid,
)
{
  $downloads                    = "C:\\Downloads"
  $cicserver_install            = "ICServer_2015_R1.msi" # TODO add wildcards to filenames?
  $interactionfirmware_install  = 'InteractionFirmware_2015_R1.msi'
  $mediaserver_install          = 'MediaServer_2015_R1.msi'

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
      # -= Requirements -=
      # ==================

      notice("Make sure .Net 3.5 is enabled")
      dism {'NetFx3':
        ensure  => present,
        all     => true,
      }

      file {"${downloads}":
        ensure  => directory,
      }

      # =================
      # -= CIC License =-
      # =================
      /*
      
      exec {"gethostid-run":
        command => "<PATH TO MODULE>/files/licensing/GetHostIDU/gethostid_clu.exe | select -index 2 | % {$_ -replace '\\s',''}",
        path      => $::path,
        cwd       => $::system32,
        provider  => powershell,
      }

      notice("Generating CIC License...")
      
      */

      # =========================
      # -= Download CIC Server -=
      # =========================

      notice("Downloading CIC Server")
      file {"${downloads}\\DownloadCICServer.ps1":
        ensure    => 'file',
        mode      => '0770',
        owner     => 'Vagrant',
        group     => 'Administrators',
        content   => "\$destPath = '${downloads}\\${cicserver_install}'
                        
                      if ((Test-path \$destPath) -eq \$true) 
                      {
                        \$destPath + ' already exists'
                      }
                      else 
                      {
                        if (Test-Path ININ:)
                        {
                          Remove-PSDrive ININ
                        }    
                        \$password = '${password}' | ConvertTo-SecureString -asPlainText -Force
                        \$credentials = New-Object System.Management.Automation.PSCredential('${username}',\$password)
                    
                        New-PSDrive -name ININ -Psprovider FileSystem -root '${media}' -credential \$credentials
                        Copy-Item ININ:\\Installs\\ServerComponents\\${cicserver_install} ${downloads}
                        Remove-PSDrive ININ
                      }",
        require   => File["${downloads}"],
        before    => Exec['cicserver-install-download'],
      }

      exec {"cicserver-install-download":
        command   => "${downloads}\\DownloadCICServer.ps1",
        creates   => "${downloads}\\${cicserver_install}",
        provider  => powershell,
      }

      # ========================
      # -= Install CIC Server -=
      # ========================

      notice("Installing CIC Server")
      exec {"cicserver-install-run":
        command  => "psexec -h -accepteula cmd.exe /c \"msiexec /i ${downloads}\\${cicserver_install} PROMPTEDPASSWORD=\"${loggedonuserpassword}\" INTERACTIVEINTELLIGENCE=\"C:\\I3\\IC\" TRACING_LOGS=\"C:\\I3\\IC\\Logs\" STARTEDBYEXEORIUPDATE=1 CANCELBIG4COPY=1 OVERRIDEKBREQUIREMENT=1 REBOOT=ReallySuppress /l*v icserver.log /qb! /norestart\"", path => $::path,
        creates  => "C:/I3/IC/Server/NotifierU.exe",
        cwd       => $::system32,
        provider => windows,
        timeout  => 1800,
        require  => [
          Exec['cicserver-install-download'],
          Dism['NetFx3'],
        ],
      }
      
      # ===================================
      # -= Download Interaction Firmware -=
      # ===================================

      notice("Downloading Interaction Firmware")
      file {"${downloads}\\DownloadInteractionFirmware.ps1":
        ensure    => 'file',
        mode      => '0770',
        owner     => 'Vagrant',
        group     => 'Administrators',
        content   => "\$destPath = '${downloads}\\${interactionfirmware_install}'
                        
                      if ((Test-path \$destPath) -eq \$true) 
                      {
                        \$destPath + ' already exists'
                      }
                      else 
                      {
                        if (Test-Path ININ:)
                        {
                          Remove-PSDrive ININ
                        }    
                        \$password = '${password}' | ConvertTo-SecureString -asPlainText -Force
                        \$credentials = New-Object System.Management.Automation.PSCredential('${username}',\$password)
                    
                        New-PSDrive -name ININ -Psprovider FileSystem -root '${media}' -credential \$credentials
                        Copy-Item ININ:\\Installs\\ServerComponents\\${interactionfirmware_install} ${downloads}
                        Remove-PSDrive ININ
                      }",
        require   => File["${downloads}"],
        before    => Exec['interactionfirmware-install-download'],
      }

      exec {'interactionfirmware-install-download':
        command   => "${downloads}\\DownloadInteractionFirmware.ps1",
        creates   => "${downloads}\\${interactionfirmware_install}",
        provider  => powershell,
      }

      # ===================================
      # -= Install Interaction Firmware -=
      # ===================================
      
      notice("Installing Interaction Firmware")
      exec {"interactionfirmware-install-run":
        command   => "psexec -h -accepteula cmd.exe /c \"msiexec /i ${downloads}\\${interactionfirmware_install} STARTEDBYEXEORIUPDATE=1 REBOOT=ReallySuppress /l*v interactionfirmware.log /qb! /norestart\"",
        path      => $::path,
        cwd       => $::system32,
        creates   => "C:/I3/IC/Server/Firmware/firmware_model_mapping.xml",
        provider  => windows,
        timeout   => 1800,
        require   => [
          Exec['cicserver-install-run'],
          Exec['interactionfirmware-install-download'],
        ],
      }

      # =====================
      # -= Setup Assistant =-
      # =====================

      notice("Creating ICSurvey file...")
      class {'icsurvey':
        path                  => $survey, # TODO Probably needs to move/generate this somewhere else
        installnodomain       => $installnodomain,
        organizationname      => $organizationname,
        locationname          => $locationname,
        sitename              => $sitename,
        dbreporttype          => $dbreporttype,      
        dbtablename           => $dbtablename,
        dialplanlocalareacode => $dialplanlocalareacode,
        emailfbmc             => $emailfbmc,
        recordingspath        => $recordingspath,
        sipnic                => $sipnic,
        outboundaddress       => $outboundaddress,
        defaulticpassword     => $defaulticpassword,    
        licensefile           => $licensefile,  
        hostid                => $hostid,
        before                => Exec['setupassistant-run'],
      }

      # If it was run before, make sure the complete version of the IC Setup Assistant is being executed
      registry_value {'HKLM\Software\WOW6432Node\Interactive Intelligence\Setup Assistant\Complete':
        type      => dword,
        data      => 0,
        before    => Exec['setupassistant-run'],
        require   => Exec['cicserver-install-run'],
      }

      notice("Running Setup Assistant...")
      exec {'setupassistant-run':
        command   => "psexec -h -accepteula c:\\i3\\ic\\server\\icsetupu.exe \"/f=$survey\"", # TODO check command parameters (-f?)
        path      => $::path,
        cwd       => $::system32,
        provider  => windows,
        timeout   => 3600,
        returns   => [0,1],
        require   => [
          #Exec['generateciclicense-run'], # re-enable when the licensing service works
          Exec['interactionfirmware-install-run'],
        ],
      }

      service {'Interaction Center':
        ensure  => running,
        enable  => true,
        require => Exec['setupassistant-run'],
      }

      # ==================
      # -= Media Server =-
      # ==================

      notice("Downloading Media Server")
      file {"${downloads}\\DownloadMediaServer.ps1":
        ensure    => 'file',
        mode      => '0770',
        owner     => 'Vagrant',
        group     => 'Administrators',
        content   => "\$destPath = '${downloads}\\${mediaserver_install}'
                        
                      if ((Test-path \$destPath) -eq \$true) 
                      {
                        \$destPath + ' already exists'
                      }
                      else 
                      {
                        if (Test-Path ININ:)
                        {
                          Remove-PSDrive ININ
                        }    
                        \$password = '${password}' | ConvertTo-SecureString -asPlainText -Force
                        \$credentials = New-Object System.Management.Automation.PSCredential('${username}',\$password)
                    
                        New-PSDrive -name ININ -Psprovider FileSystem -root '${media}' -credential \$credentials
                        Copy-Item ININ:\\Installs\\Off-ServerComponents\\${mediaserver_install} ${downloads}
                        Remove-PSDrive ININ
                      }",
        require   => File["${downloads}"],
        before    => Exec['mediaserver-install-download'],
      }

      exec {'mediaserver-install-download':
        command   => "${downloads}\\DownloadMediaServer.ps1",
        creates   => "${downloads}\\${mediaserver_install}",
        provider  => powershell,
      }

      notice("Installing Media Server")
      exec {"mediaserver-install-run":
        command   => "psexec -h -accepteula cmd.exe /c \"msiexec /i ${downloads}\\${mediaserver_install} MEDIASERVER_ADMINPASSWORD_ENCRYPTED='CA1E4FED70D14679362C37DF14F7C88A' /l*v mediaserver.log /qb! /norestart\"",
        path      => $::path,
        cwd       => $::system32,
        creates   => "C:/I3/IC/Server/mediaprovider_w32r_2_0.dll",
        provider  => windows,
        returns   => [0,3010],
        timeout   => 1800,
        require   => [
          Exec['mediaserver-install-download'],
          Exec['setupassistant-run'],
        ],
      }
      
      # ==============================
      # -= Configuring Media Server =-
      # ==============================

      notice("Setting web config login password")
      registry_value {'HKLM\Software\WOW6432Node\Interactive Intelligence\MediaServer\WebConfigLoginPassword':
        type      => string,
        data      => 'CA1E4FED70D14679362C37DF14F7C88A',
        require   => [
          Exec['mediaserver-install-run'],
        ],
      }
      
      notice("Install Media Server license")
      #TODO GENERATE LICENSE FOR MEDIA SERVER
      
      registry_value {'HKLM\Software\WOW6432Node\Interactive Intelligence\MediaServer\LicenseFile':
        type      => string,
        data      => $mediaserverlicensefile,
        require   => Exec['mediaserver-install-run'],
        before    => Service['ININMediaServer'],
      }
      
      notice("Starting Media Server")
      service {'ININMediaServer':
        ensure    => running,
        enable    => true,
        require   => Exec['mediaserver-install-run'],
      }
      
      notice("Pairing CIC and Media server")
      $server = $::hostname
      $mediaserver_registrationurl = "https://${server}/config/servers/add/postback"
      $mediaserver_registrationnewdata = "NotifierHost=${server}&NotifierUserId=vagrant&NotifierPassword=1234&AcceptSessions=true&PropertyCopySrc=&_Command=Add"
      
      file {"mediaserver-pairing":
        ensure    => present,
        path      => "C:\\mediaserverpairing.ps1",
        content   => "
        [System.Net.ServicePointManager]::ServerCertificateValidationCallback = {\$true}
        \$uri = New-Object System.Uri (\"${mediaserver_registrationurl}\")
        \$secpasswd = ConvertTo-SecureString \"1234\" -AsPlainText -Force
        \$mycreds = New-Object System.Management.Automation.PSCredential (\"admin\", \$secpasswd)
        
        \$mediaserverPath = \"c:\\i3\\ic\\resources\\MediaServerConfig.xml\"
        \$commandServerCount = 0
        \$finishedLongWait = \$false;

        for(\$provisionCount = 0; \$provisionCount -lt 15; \$provisionCount++)
        {
            try { 
                \$r = Invoke-WebRequest -Uri \$uri.AbsoluteUri -Credential \$mycreds  -Method Post -Body \"${mediaserver_registrationnewdata}\"
                
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
        
        \$certs = Get-ChildItem -Path \"hklm:\\Software\\Wow6432Node\\Interactive Intelligence\\EIC\\Directory Services\\Root\\${sitename}\\Production\\Config Certificates\\Config Subsystems Certificates\"
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
        require   => [
          Service['ININMediaServer'],
        ],
      }
      
      exec {"mediaserver-pair-cic":
        command   => "C:\\mediaserverpairing.ps1",
        provider  => powershell,
        require   => [
          File['mediaserver-pairing'],
          Exec['cicserver-install-run'],
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
