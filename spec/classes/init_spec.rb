require 'spec_helper'
describe 'icsurvey' do

  context 'it should compile' do
  	it {should compile}
  end
  
  context 'with defaults for all parameters' do
    it { should contain_class('icsurvey') }
  end
end
