#
# Gets the latest version of a file
#
# Usage: latest_version(dir, pattern)
#
# params:
#
# - dir: path to files
# - pattern: file matching pattern
#

#require 'fileutils'

module Puppet::Parser::Functions
  newfunction(:latest_version, :type => :rvalue) do |args|
  	directory = args[0]
  	pattern = args[1]

  	debug "Getting latest version of " + pattern + " in " + directory
	Dir.chdir(directory)
	files = Dir.glob(pattern)

	latestversion = files.max()
	latestversion
  end
end