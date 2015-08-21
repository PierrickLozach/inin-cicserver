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

  context 'should create survey' do
    it { should contain_file('icsurvey') }
  end
end

describe 'cicserver::user' do
  
  let(:facts) {{ :operatingsystem => 'Windows' }}
  
  context 'username is required' do
    it do
      expect {
        should contain_class('cicserver::user') 
      }.to raise_error(Puppet::Error, /Must pass username/)
    end
  end

  context 'should call a powershell script' do
    let(:params) {{ 
      :username         => 'aCICUser',
      :extension        => 8001,
      :cicadminusername => 'cicadmin',
      :cicadminpassword => 'strong password',
    }}
    it { should contain_exec('create-ic-user') }
  end
end

describe 'cicserver::workgroup' do
  
  let(:facts) {{ :operatingsystem => 'Windows' }}
  
  context 'workgroupname is required' do
    it do
      expect {
        should contain_class('cicserver::workgroup') 
      }.to raise_error(Puppet::Error, /Must pass workgroupname/)
    end
  end

  context 'should call a powershell script' do
    let(:params) {{ 
      :workgroupname    => 'aCICUser',
      :extension        => 8001,
      :members          => ['testuser1', 'testuser2'],
      :cicadminusername => 'cicadmin',
      :cicadminpassword => 'strong password',
    }}
    it { should contain_exec('create-ic-workgroup') }
  end
end

# Disabling cicserver::install tests for now until I can test the download_file function correctly
=begin
describe 'cicserver::install' do
    let(:facts) {{ :operatingsystem => 'Windows' }}
    let(:params) {{ 
      :ensure                => 'installed',
      :survey                => 'c:/i3/ic/manifest/newsurvey.icsurvey',
      :installnodomain       => true,
      :organizationname      => 'testorg',
      :locationname          => 'testloc',
      :sitename              => 'testsite',
      :dbreporttype          => 'db',
      :dbservertype          => 'mssql',
      :dbtablename           => 'I3_IC',
      :dialplanlocalareacode => '317',
      :emailfbmc             => false,
      :recordingspath        => 'some path to the recordings',
      :sipnic                => 'some NIC',
      :outboundaddress       => 'some outbound address',
      :defaulticpassword     => 'some default password',
      :licensefile           => 'some path to the CIC license',
      :loggedonuserpassword  => 'some password',
    }}

  context 'should take care of Windows before starting' do
    it { should contain_exec('disable-automatic-maintenance') } # Turn off Windows maintenance before running MSIs
  end

  context 'should configure CIC' do
    it { should contain_exec('setupassistant-run') } # Run Setup Assistant
    it { should contain_service('cicserver-service-start') } # Start CIC service
  end

  context 'should install and configure Media Server' do

    # Install GA
    it { should contain_exec('mount-cic-iso') }
    it { should contain_package('mediaserver')}
    it { should contain_exec('unmount-cic-iso') }

    # Install Latest patch
    it { should contain_exec('mount-cic-latest-patch') }
    it { should contain_file('mediaserver-latest-patch-script') }
    it { should contain_exec('mediaserver-latest-patch-run') }
    it { should contain_exec('unmount-cic-latest-patch') }

    # Configure
    it { should contain_file('c:/i3/ic/mediaserverlicense.i3lic') } # Create the license file
    it { should contain_exec('ININMediaServer-Start') } # Start the service
    it { should contain_file('mediaserver-pairing') } # Create a powershell script to pair media server with CIC
    it { should contain_exec('mediaserver-pair-cic') } # Run the powershell script
  end

end
=end