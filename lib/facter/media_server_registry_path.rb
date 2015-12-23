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

Facter.add(:media_server_registry_path) do
  confine :osfamily => "Windows"
  setcode do
    require 'win32/registry'

    if key_exists?('SOFTWARE\Wow6432Node\Interactive Intelligence\MediaServer')
      path = 'HKLM\Software\WOW6432Node\Interactive Intelligence\MediaServer'
    elsif key_exists?('SOFTWARE\Interactive Intelligence\MediaServer')
      path = 'HKLM\Software\Interactive Intelligence\MediaServer'
    else
      # Not sure which default value to use for now...
      path = 'HKLM\Software\Interactive Intelligence\MediaServer'
    end

    media_server_registry_path = path
  end
end
