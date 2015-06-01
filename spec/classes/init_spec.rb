require 'puppetlabs_spec_helper/module_spec_helper'
require 'spec_helper'

describe 'cicserver::icsurvey' do

  context 'with defaults for all parameters' do
    it { should contain_class('cicserver::icsurvey') }
  end

  context 'with invalid path' do
    let(:params) {{ :path => 'some invalid path' }}
    it do
      expect {
        should contain_class('cicserver::icsurvey') 
      }.to raise_error(Puppet::Error, /\"some invalid path\" is not an absolute path./)
    end
  end

  context 'with invalid emailfbmc value' do
    let(:params) {{ :emailfbmc => 'some invalid boolean value' }}
    it do
      expect {
        should contain_class('cicserver::icsurvey') 
      }.to raise_error(Puppet::Error, /\"some invalid boolean value\" is not a boolean.  It looks to be a String./)
    end
  end

  context 'should create manifest dir' do
  	it { should contain_file('C:\\\\I3\\\\IC\\\\Manifest') }
  end

  context 'should create survey' do
  	it { should contain_file('icsurvey') }
  end

end

describe 'cicserver::install' do

  context 'with valid values for all parameters' do

  	let(:facts) { { :operatingsystem => 'Windows'} }

  	let(:params) {{ 
  		:survey => 'c:/I3/IC/Manifest/newsurvey.icsurvey', 
  		:installnodomain => true, 
  		:organizationname => 'testorg', 
  		:locationname => 'testloc', 
  		:sitename => 'testsite',
  		:dbreporttype => 'db',
  		:dbservertype => 'mssql',
  		:dbtablename => 'I3_IC',
  		:dialplanlocalareacode => '317',
  		:emailfbmc => true,
  		:recordingspath => 'C:/I3/IC/Recordings',
  		:sipnic => 'Ethernet',
  		:outboundaddress => '3178723000',
  		:defaulticpassword => '1234',
  		:licensefile => 'C:/vagrant-data/cic-license.i3lic',
  		:loggedonuserpassword  => 'vagrant' }}
  	it { should contain_class('cicserver::install') }
  end

end