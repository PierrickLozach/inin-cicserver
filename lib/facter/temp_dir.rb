Facter.add(:temp_dir) do
  setcode do
    require 'tmpdir'
    temp_dir = Dir.tmpdir()
  end
end