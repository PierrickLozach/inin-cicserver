def key_exists?(path_reg)
  begin
    Win32::Registry::HKEY_LOCAL_MACHINE.open(path_reg, ::Win32::Registry::KEY_READ | 0x100 )
    return true
  rescue
    return false
  end
end

def readkey(path_reg,value)
  begin
    mykey = Win32::Registry.open(Win32::Registry::HKEY_LOCAL_MACHINE,path_reg,Win32::Registry::Constants::KEY_READ | 0x100)
    return mykey[value]
  rescue
    return false
  end
end

Facter.add(:cic_icws_licensed) do
  confine :osfamily => "Windows"
  setcode do
    require 'win32/registry'

    #if Facter.value(:cic_configured) == 'true'
    #begin
      cic_site_name = readkey('SOFTWARE\Wow6432Node\Interactive Intelligence\Directory Services\Root', 'SITE')
      cic_icws_licensed = key_exists?('SOFTWARE\Wow6432Node\Interactive Intelligence\EIC\Directory Services\Root' + cic_site_name + '\Production\Licenses\I3_FEATURE_ICWS_SDK')
    #end

  #end
  end
end
