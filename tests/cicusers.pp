class {'cicserver::users':
  ensure           => installed,
  cicuserdata      => '{ { asdasdd => { username => "testuser1", password => "1234", extension => "8001" }, { kajdkjdf => { username => "testuser2", password => "5678", extension => "8002" } }',
  pathtoscripts    => 'C:/Users/Vagrant/Desktop/Scripts/posh-ic',
  cicadminusername => 'vagrant',
  cicadminpassword => '1234',
  cicserver        => 'localhost',
}
