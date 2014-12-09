# == Class: icsurvey
#
# Creates an ICSurvey file for automation purposes to run the IC Setup Assistant silently
#
# === Parameters
#
# Document parameters here.
#
# [path]
#	Required. Full path to the output icsurvey file.
#
# [installnodomain]
# 	Set to trure if no domain is configured.
#
# [organizationname]
# 	Interaction Center Organization Name. Defaults to cicorg.
#
# [locationname]
# 	Interaction Center location name.
#
# [sitename]
#	Interaction Center Site Name. Defaults to cicsite.
#
# [dbreporttype]
#	Database report type. Only 'db' is supported for now.
#
# [dbservertype]
# 	Database server type. Only 'mssql' is supported for now.
#
# [dbtablename]
#	Database table name. Defaults to I3_IC.
#
# [dialplanlocalareacode]
#	local area code. Defaults to 317.
#
# [emailfbmc]
#	Set to true to enable IC's FBMC (File Based Mail Connector). Defaults to false.
#
# [recordingspath]
#	Path to store the compressed recordings. Defaults to C:/I3/IC/Recordings.
#
# [sipnic]
#	Name of the network card (NIC) to use for SIP/RTP transport. Defaults to Ethernet.
#
# [outboundaddress]
#	Phone number to show for outbound calls. Defaults to 3178723000.
#
# [defaulticpassword]
#	Default IC user password. Defaults to 1234.
#
# [licensefile]
#	Path to the .i3lic file
#
# [hostid]
# 	host id to use with the license file
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if
#   it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)
#
# === Examples
#
#  class {'pierrick-icsurvey':
#	path 					=> 'c:/users/vagrant/desktop/newsurvey.icsurvey',
# 	cicservername			=> 'WIN-TESTMACHINE',
# 	installnodomain			=> true,			
# 	organizationname		=> 'organizationname',
# 	locationname			=> 'locationname',
# 	sitename				=> 'sitename',
# 	dbreporttype			=> 'db', 			
# 	dbtablename				=> 'I3_IC',
# 	dialplanlocalareacode	=> '317',			
# 	emailfbmc				=> true,
# 	recordingspath			=> "C:\\I3\\IC\\Recordings",
# 	sipnic					=> 'Ethernet',
# 	outboundaddress			=> '3178723000',
# 	defaulticpassword		=> '1234',		
# 	licensefile				=> "c:\\users\\vagrant\\desktop\\iclicense.i3lic",	
# 	hostid					=> '6300270E26DF',
#  }
#
# === Authors
#
# Pierrick Lozach <pierrick.lozach@inin.com>
#
# === Copyright
#
# Copyright 2015, Interactive Intelligence Inc.
#
class pierrick-icsurvey (
	$path 					= 'c:/users/vagrant/desktop/NewSurvey.ICSurvey',
	$installnodomain 		= true,
	$organizationname		= 'organizationname',
	$locationname 			= 'locationname',
	$sitename				= 'sitename',
	$dbreporttype 			= 'db',
	$dbservertype 			= 'mssql',
	$dbtablename 			= 'I3_IC',
	$dialplanlocalareacode 	= '317',
	$emailfbmc 				= false,
	$recordingspath 		= "c:\\I3\\IC\\Recordings",
	$sipnic 				= 'Ethernet',
	$outboundaddress 		= '3178723000',
	$defaulticpassword 		= '1234',
	$licensefile			= "c:\\users\\vagrant\\desktop\\iclicense.i3lic",
	$hostid,
){

	require stdlib

	validate_absolute_path($path)
	validate_bool($emailfbmc)

	if ($emailfbmc) {
		$emailselected = 1
		$usefbmc = 1
	}
	else {
		$emailselected = 0
	}

	$useinstallnodomain = $installnodomain ? # got to find a better name for this
	{
		false 	=> 0,
		true 	=> 1,
	}

	file { "icsurvey":
			ensure 	=> present,
	        path    => $path,
	        mode    => '0777',
	        content => template('pierrick-icsurvey/DefaultSurvey.ICSurvey.erb'),
	      }

}
