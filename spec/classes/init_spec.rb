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

  context 'should take care of Windows before starting' do
    it { should contain_exec('disable-automatic-maintenance') } # Turn off Windows maintenance before running MSIs
  end

  context 'should create survey' do
    it { should contain_file('C:\\\\I3\\\\IC\\\\Manifest') }
  	it { should contain_file('icsurvey') }
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

