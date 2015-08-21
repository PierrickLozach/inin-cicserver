class {'cicserver::workgroup':
  ensure           => installed,
  username         => 'testworkgroup1',
  extension        => 8001,
  members          => ['testuser1', 'testuser2']
  pathtoscripts    => 'C:/Users/Vagrant/Desktop/Scripts/posh-ic/lib',
  cicadminusername => 'vagrant',
  cicadminpassword => '1234',
  cicserver        => 'testregfr',
}