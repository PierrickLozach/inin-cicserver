class {'cicserver::icsurvey':
	path 					=> 'c:/i3/ic/manifest/newsurvey.icsurvey',
	installnodomain			=> true,			
	organizationname		=> 'organizationname',
	locationname			=> 'locationname',
	sitename				=> 'sitename',
	dbreporttype			=> 'db', 			
	dbtablename				=> 'I3_IC',
	dialplanlocalareacode	=> '317',			
	emailfbmc				=> true,
	recordingspath			=> "c:\\I3\\IC\\Recordings",
	sipnic					=> 'Ethernet 2',
	outboundaddress			=> '3178723000',
	defaulticpassword		=> '1234',		
	licensefile				=> "c:\\users\\vagrant\\desktop\\license.i3lic",	
	hostid					=> '6300270E26DF',
}