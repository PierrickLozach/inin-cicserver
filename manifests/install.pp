# == Class: cicserver::install
#
# Installs CIC, Interaction Firmware and Media Server then pairs the Media server with the CIC server. All silently.
#
# === Parameters
#
# [ensure]
#   installed. No other values are currently supported.
#
# [source]
#   location of the ININ MSI files. Should contain the Installs directory.
#
# [source_user]
#   Optional. Username to access the source specified previously.
#
# [source_password]
#   Optional. Password to access the source specified previously.
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
#   source                  => '\\\\servername\\path_to_installs_folder',
#   source_user             => '',
#   source_password         => '',
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
#   loggedonuserpassword    => 'vagrant',
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
  $source,
  $source_user,
  $source_password,
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
  $loggedonuserpassword,
  $hostid,
)
{
  $cicserver_install            = "ICServer_2015_R1.msi" # TODO add wildcards to filenames?
  $interactionfirmware_install  = 'InteractionFirmware_2015_R1.msi'
  $mediaserver_install          = 'MediaServer_2015_R1.msi'

  if ($operatingsystem != 'Windows')
  {
    err("This module works on Windows only!")
    fail("Unsupported OS")
  }

  $cache_dir = hiera('core::cache_dir', 'c:/users/vagrant/appdata/local/temp') # If I use c:/windows/temp then a circular dependency occurs when used with SQL
  if (!defined(File["${cache_dir}"]))
  {
    file {"${cache_dir}":
      ensure   => directory,
      provider => windows,
    }
  }

  case $ensure
  {
    installed:
    {

      # ===================================
      # -= Download Interaction Firmware -=
      # ===================================

      debug("Downloading Interaction Firmware")
      download_file("${interactionfirmware_install}", "${source}\\Installs\\ServerComponents", "${cache_dir}", "${source_user}", "${source_password}")

      # ===================================
      # -= Install Interaction Firmware -=
      # ===================================
      
      debug("Installing Interaction Firmware")
      exec {"interactionfirmware-install-run":
        command   => "msiexec /i ${cache_dir}\\${interactionfirmware_install} STARTEDBYEXEORIUPDATE=1 REBOOT=ReallySuppress /l*v interactionfirmware.log /qn /norestart",
        path      => $::path,
        cwd       => $::system32,
        creates   => "C:/I3/IC/Server/Firmware/firmware_model_mapping.xml",
        provider  => powershell,
        timeout   => 1800,
      }

      # =====================
      # -= Setup Assistant =-
      # =====================

      debug("Creating ICSurvey file...")
      class {'cicserver::icsurvey':
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

      debug("Creating Setup Assistant powershell script...")
      file {"${cache_dir}\\RunSetupAssistant.ps1":
        ensure  => 'file',
        owner   => 'Vagrant',
        group   => 'Administrators',
        content => "
        \$LogFile=\"${cache_dir}\\salog.txt\"

        function LogWrite
        {
          Param ([string]\$logstring)
          Add-content \$LogFile -value \$logstring
        }

        function WaitForSetupAssistantToFinish
        {
          Write-Host 'Waiting for Setup Assistant to finish...'
          LogWrite 'Waiting for Setup Assistant to finish...'
          do
          {
            sleep 10
            \$sacomplete = Get-ItemProperty (\"hklm:\\software\\Wow6432Node\\Interactive Intelligence\\Setup Assistant\") -name Complete | Select -exp Complete
            LogWrite 'Setup Assistant Complete? ' 
            LogWrite \$sacomplete
          }while (\$sacomplete -eq 0)
        }
        
        Write-Host \"Starting Setup Assistant... this will take a while to complete. Please wait...\"
        LogWrite 'Starting setup assistant...'
        Invoke-Expression \"C:\\I3\\IC\\Server\\icsetupu.exe /f=$survey\"
        WaitForSetupAssistantToFinish

        LogWrite 'Sleeping for 180 seconds while waiting for setup assistant to finish.'
        Start-Sleep -s 180
        LogWrite 'Sleeping is done. Setup assistant is done.'
        ",
      }

      debug("Running setup assistant")
      exec {'setupassistant-run':
        command   => "${cache_dir}\\RunSetupAssistant.ps1",
        onlyif    => [
          "if ((Get-ItemProperty (\"hklm:\\software\\Wow6432Node\\Interactive Intelligence\\Setup Assistant\") -name Complete | Select -exp Complete) -eq 1) {exit 1}", # Don't run if it has been completed before
          "if ((Get-ItemProperty (\"${licensefile}\") -name Length | Select -exp Length) -eq 0) {exit 1}", # Don't run if the license file size is 0
          ],
        provider  => powershell,
        timeout   => 3600,
        require   => [
          Exec['interactionfirmware-install-run'],
          File["${cache_dir}\\RunSetupAssistant.ps1"],
          Class['cicserver::icsurvey'],
        ],
      }

      debug("Starting Interaction Center")
      service {'cicserver-service-start':
        name    => 'Interaction Center',
        ensure  => running,
        require => Exec['setupassistant-run'],
        before  => Package['mediaserver'],
      }

      # ===========================
      # -= Download Media Server =-
      # ===========================

      debug("Downloading Media Server")
      download_file("${mediaserver_install}", "${source}\\Installs\\Off-ServerComponents", "${cache_dir}", "${source_user}", "${source_password}")

      # ==========================
      # -= Install Media Server =-
      # ==========================

      debug("Installing Media Server")
      package {'mediaserver':
        ensure          => installed,
        source          => "${cache_dir}\\${mediaserver_install}",
        install_options => ['/qn', '/norestart', { 'MEDIASERVER_ADMINPASSWORD_ENCRYPTED' => 'CA1E4FED70D14679362C37DF14F7C88A' }],
        require         => Exec['setupassistant-run'],
      }

      # ==============================
      # -= Configuring Media Server =-
      # ==============================

      debug("Setting web config login password")
      registry_value {'HKLM\Software\WOW6432Node\Interactive Intelligence\MediaServer\WebConfigLoginPassword':
        type      => string,
        data      => 'CA1E4FED70D14679362C37DF14F7C88A',
        require   => Package['mediaserver'],
      }
      
      debug("Install Media Server license")
      #TODO GENERATE LICENSE FOR MEDIA SERVER
      
      registry_value {'HKLM\Software\WOW6432Node\Interactive Intelligence\MediaServer\LicenseFile':
        type      => string,
        data      => $mediaserverlicensefile,
        require   => Package['mediaserver'],
        before    => Service['ININMediaServer'],
      }
      
      debug("Starting Media Server")
      service {'ININMediaServer':
        ensure    => running,
        enable    => true,
        require   => Package['mediaserver'],
      }
      
      $server = $::hostname
      $mediaserver_registrationurl = "https://${server}/config/servers/add/postback"
      $mediaserver_registrationnewdata = "NotifierHost=${server}&NotifierUserId=vagrant&NotifierPassword=1234&AcceptSessions=true&PropertyCopySrc=&_Command=Add"
      
      debug("Creating script to pair CIC and Media server")
      file {"mediaserver-pairing":
        ensure    => present,
        path      => "${cache_dir}\\mediaserverpairing.ps1",
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
      
        debug("Pairing CIC and Media server")
        exec {"mediaserver-pair-cic":
        command   => "${cache_dir}\\mediaserverpairing.ps1",
        provider  => powershell,
        require   => [
          File['mediaserver-pairing'],
          Package['mediaserver'],
        ],
      }
      
    }
    uninstalled:
    {
      debug('Uninstalling CIC server')
    }
    default:
    {
      fail("Unsupported ensure \"${ensure}\"")
    }
  }
}
