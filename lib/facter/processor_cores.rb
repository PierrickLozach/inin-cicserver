Facter.add(:processor_cores) do
  confine :osfamily => "Windows"
  setcode do
    require 'win32ole'
    wmi = WIN32OLE.connect("winmgmts://")
    cpu = wmi.ExecQuery("select NumberOfCores from Win32_Processor")
    
    processor_cores = cpu.to_enum.first.NumberOfCores
    processor_cores = processor_cores.to_s.rjust(2, '0') # Add a leading 0 if < 10
    processor_cores
  end
end