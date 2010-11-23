require 'spec_helper'
include Chouette::Geocoder

describe RoadSection do

  describe "class method parse_postgis_point" do

    it "should parse 'POINT(663256.203020271 2445458.04706413)' into a LatLng" do
      RoadSection.parse_postgis_point("POINT(663256.203020271 2445458.04706413)").should == GeoKit::LatLng.new(2445458.04706413, 663256.203020271)  
    end
    
  end

end
