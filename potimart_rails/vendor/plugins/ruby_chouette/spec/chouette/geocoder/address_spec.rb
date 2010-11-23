require 'spec_helper'
include Chouette::Geocoder

describe Address do

  before(:each) do
    @road = Factory(:road)
    @address = Address.new(@road, 42)
  end

  describe "name" do
    
    it "should be the road name without street_number" do
      @address.stub!(:street_number)
      @address.name.should == @road.name
    end

    it "should be the street number and road name" do
      @address.name.should == "#{@address.street_number} #{@road.name}"
    end

  end

  describe "to_lat_lng" do

    before(:each) do
      @lat_lng = GeoKit::LatLng.new(1,1)
      @section = mock RoadSection, :lat_lng_at => @lat_lng
      @road.stub!(:section_at).and_return(@section)
    end

    it "should return LatLng found by section at the street_number" do
      @section.should_receive(:lat_lng_at).with(@address.street_number).and_return(@lat_lng)
      @address.to_lat_lng.should == @lat_lng
    end

    it "should find section according the street number" do
      @road.should_receive(:section_at).with(@address.street_number).and_return(@section)
      @address.to_lat_lng
    end

    it "should find section according to number at half street without a given street number" do
      @address.stub!(:street_number)
      @address.stub!(:number_at_half_street).and_return(10)
      @road.should_receive(:section_at).with(10).and_return(@section)
      @address.to_lat_lng
    end
    
  end

end
