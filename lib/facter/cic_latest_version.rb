Facter.add(:cic_latest_version) do
  setcode do
		Dir.chdir("C:/daas-cache")
		files = Dir.glob("CIC_[0-9]*_R?.iso")

		latestversion = files.max()
		latestversion  
	end
end