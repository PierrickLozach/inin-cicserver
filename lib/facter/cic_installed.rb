def key_exists?(path_reg)
  begin
    Win32::Registry::HKEY_LOCAL_MACHINE.open(path_reg, ::Win32::Registry::KEY_READ | 0x100 )
    return true
  rescue
    return false
  end
end

Facter.add(:cic_installed) do
  confine :osfamily => "Windows"
  setcode do
    require 'win32/registry'
    cic_installed = key_exists?('SOFTWARE\Wow6432Node\Interactive Intelligence\Installed\Interaction Center Server')
  end
end