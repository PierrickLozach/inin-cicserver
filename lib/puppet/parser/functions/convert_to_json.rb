#
# Converts a hash to json
#
# Usage: convert_to_json(hash)
#
# params:
#
# - hash: ruby hash to convert
#

#require 'fileutils'

module Puppet::Parser::Functions
  newfunction(:convert_to_json, :type => :rvalue) do |args|
  	hash = args[0]

  	debug "Converting hash to json..."
  	hashjson = hash.to_json
  	puts hashjson

  	hashjson
  end
end