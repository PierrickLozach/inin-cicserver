#
# Downloads a file
#
# Usage: download_file(filename, source, destination, username, password)
#
# params:
#
# - filename: file to copy
# - source: path containing the file to copy
# - destination: folder to copy the file to
# - username: (optional) username required to access the source path/filename
# - password: (optional) password for the above user
#
# UNC EXAMPLE: download_file("InteractionFirmware_2015_R1.msi", "\\\\192.168.0.22\\Logiciels\\ININ\\2015R1\\CIC_2015_R1\\Installs\\ServerComponents", "C:\\Users\\Pierrick\\Desktop")
# URL EXAMPLE: download_file("Brazilian%20Trance.wav-13722-Free-Loops.com.mp3","http://dight310.byu.edu/media/audio/FreeLoops.com/2/2","C:\\Windows\\Temp")
#
# TODO Find out which network drive is free?
# TODO Need to support fallback path (default path)
#

require 'fileutils'
require 'open-uri'
require 'win32ole'

module Puppet::Parser::Functions
  newfunction(:download_file) do |args|
  	filename = args[0]
  	path = args[1]
  	destination = args[2]

  	if (path.match("^\\\\.*"))

  		debug "Downloading from a UNC path"
		net = WIN32OLE.new('WScript.Network')
		if (args[3].empty?)
			net.MapNetworkDrive('Z:', path)
		else
			username = args[3] # Check if param is empty or not present?
			password = args[4]
			net.MapNetworkDrive('Z:', path, false, username, password)
		end

	  	FileUtils.cp_r("Z:\\" + filename, destination)
	  	debug "Copy finished. Removing network drive"
	  	net.RemoveNetworkDrive('Z:')

    elsif (path.match("^((https|http|ftp|ftps)?:\/\/)?"))

    	debug "Downloading from an external path"
		File.open(destination + "\\" + filename, 'wb') do |saved_file|
		  open(path + "/" + filename, 'rb') do |read_file|
		  	saved_file.write(read_file.read)
		  end
		end
	  	debug "Copy finished."

	else

		debug "Downloading from a local copy"
	  	FileUtils.cp_r(path + "\\" + filename, destination)
	  	debug "Copy finished."

	end
  end
end