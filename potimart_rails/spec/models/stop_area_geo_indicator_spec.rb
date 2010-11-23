require 'spec_helper'

describe StopAreaGeoIndicator do
  describe 'create' do
    it 'should stop area geo indicator valid' do
      stop_area_geo_indicator = Factory(:stop_area_geo_indicator)
      stop_area_geo_indicator.should be_valid
    end
  end
  describe 'names' do
    it 'must return 2 names' do
      indicator1 = Factory(:stop_area_geo_indicator)
      indicator2 = Factory(:stop_area_geo_indicator)
      indicator3 = Factory.build(:stop_area_geo_indicator, :name => 'Indicator1')
      test = StopAreaGeoIndicator.names.count
      test.should == 2
    end
  end
end
