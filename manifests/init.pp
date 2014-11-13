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
      exec {"net35":
        command => 'Dism /Online /Enable-Feature /FeatureName:NetFx3 /All',    
      }
      
      notice("Downloading CIC Server")
      $cicserver_source = '\\\\192.168.0.22\\Logiciels\\ININ\\CIC2015R1\\Uncompressed\\Installs\\ServerComponents\\ICServer_2015_R1.msi'
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
