def value_exists?(path,key)
  reg_type = Win32::Registry::KEY_READ 
  Win32::Registry::HKEY_LOCAL_MACHINE.open(path, reg_type) do |reg|
    begin
      regkey = reg[key]
    rescue
      return nil
    end
  end
end

# Example: 2015
Facter.add(:cic_installed_major_version) do
  confine :osfamily => "Windows"
  setcode do
    require 'win32/registry'
    cic_current_version = value_exists?('SOFTWARE\Wow6432Node\Interactive Intelligence\Installed\IC System Manager', '')
    cic_installed_major_version = '20' + /([0-9]+)\.([0-9]+)\.([0-9]+)\.([0-9]+)/.match(cic_current_version)[1]
  end
end

# Example: 3 (for R3)
Facter.add(:cic_installed_release) do
  confine :osfamily => "Windows"
  setcode do
    require 'win32/registry'
    cic_current_version = value_exists?('SOFTWARE\Wow6432Node\Interactive Intelligence\Installed\IC System Manager', '')
    cic_installed_release = /([0-9]+)\.([0-9]+)\.([0-9]+)\.([0-9]+)/.match(cic_current_version)[2]
  end
end

# Example: 2 (for Patch2)
Facter.add(:cic_installed_patch) do
  confine :osfamily => "Windows"
  setcode do
    require 'win32/registry'
    cic_current_version = value_exists?('SOFTWARE\Wow6432Node\Interactive Intelligence\Installed\IC System Manager', '')
    cic_installed_patch = /([0-9]+)\.([0-9]+)\.([0-9]+)\.([0-9]+)/.match(cic_current_version)[3]
  end
end

# Example: 28 (for .28 in 15.3.2.28)
Facter.add(:cic_installed_minor_version) do
  confine :osfamily => "Windows"
  setcode do
    require 'win32/registry'
    cic_current_version = value_exists?('SOFTWARE\Wow6432Node\Interactive Intelligence\Installed\IC System Manager', '')
    cic_installed_minor_version = /([0-9]+)\.([0-9]+)\.([0-9]+)\.([0-9]+)/.match(cic_current_version)[4]
  end
end