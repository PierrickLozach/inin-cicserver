class {'cicserver':
	ensure				=> installed,
	media				=> "\\\\192.168.0.22\\ININ\\2015_R1\\CIC_2015_R1",
	username			=> 'admin',
	password			=> 'Vero052408',
	organization 		=> 'organizationname',
	location 			=> 'locationname',
	site 				=> 'sitename',
	outboundaddress		=> "3178723000",
}