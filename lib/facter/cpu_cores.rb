Facter.add(:processor_cores) do
  confine :osfamily => "Windows"
  setcode do
    require 'win32ole'
    wmi = WIN32OLE.connect("winmgmts://")
    cpu = wmi.ExecQuery("select NumberOfCores from Win32_Processor")
    
    processor_cores = cpu.to_enum.first.NumberOfCores
  end
end