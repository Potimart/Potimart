require 'spec_helper'

describe LineIndicator do
  describe 'create' do
    it 'should line indicator valid' do
      line_indicator = Factory(:line_indicator)
      line_indicator.should be_valid
    end
  end
  describe 'names' do
    it 'must return 2 names' do
      indicator1 = Factory(:line_indicator)
      indicator2 = Factory(:line_indicator)
      indicator3 = Factory.build(:line_indicator, :name => 'Indicator1')
      test = LineIndicator.names.count
      test.should == 2
    end
  end
end
