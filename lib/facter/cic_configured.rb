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

Facter.add(:cic_configured) do
  confine :osfamily => "Windows"
  setcode do
    require 'win32/registry'

    if key_exists?('SOFTWARE\Wow6432Node\Interactive Intelligence\Setup Assistant')
      complete = readkey('SOFTWARE\Wow6432Node\Interactive Intelligence\Setup Assistant', 'Complete')
    end

    cic_configured = complete == 0x00000001
  end
end