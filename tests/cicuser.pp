class {'cicserver::user':
  ensure           => installed,
  username         => 'testuser1',
  password         => '1234',
  extension        => 8001,
  pathtoscripts    => 'C:/Users/Vagrant/Desktop/Scripts/posh-ic/lib',
  cicadminusername => 'vagrant',
  cicadminpassword => '1234',
  cicserver        => 'testregfr',
}