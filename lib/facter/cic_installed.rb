Facter.add(:cic_installed) do
  confine :osfamily => "Windows"
  setcode do
    require 'win32/registry'

    hive = Win32::Registry::HKEY_LOCAL_MACHINE
    cic_installed = hive.open('SOFTWARE\Wow6432Node\Interactive Intelligence\Installed\Interaction Center Server',  Win32::Registry::KEY_READ | 0x100) {|reg| true } return false

  end
end