require 'spec_helper'
Coveralls.wear!

describe 'icsurvey' do

  context 'with defaults for all parameters' do
    it { should contain_class('icsurvey') }
  end
end
