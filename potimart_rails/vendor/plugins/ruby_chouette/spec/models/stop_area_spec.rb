# -*- coding: utf-8 -*-
require File.join(File.dirname(__FILE__),'../spec_helper')

describe StopArea do

  before(:each) do
    @stop_area = Factory(:stop_area)
  end

  describe "geopartition" do
    def latlng(val)
      GeoKit::LatLng.new(val,val)
    end
    it "should return partition depending on geometry" do
      ep = 0.000001
      locations = [
        a = latlng(1),    b = latlng(2),    c = latlng(3),    d = latlng(4),
        e = latlng(1+ep), f = latlng(2+ep), g = latlng(3+ep),
        h = latlng(1-ep)]

      partition = StopArea.geo_partition(locations,1)

      partition.should include [a,e,h]
      partition.should include [b,f]
      partition.should include [c,g]
      partition.should include [d]

      partition = StopArea.geo_partition(locations,10000)

      partition.should include [a,b,c,d,e,f,g,h]
    end
  end

  describe "search by name" do

    before(:each) do
      @stop_area = Factory(:stop_area, :name => "stop_name")
    end

    it "should found twice if matchs fully the stop area name" do
      StopArea.find_by_name("stop_name").should =~ [ @stop_area ]*2
    end

    it "should found once if matchs partially" do
      StopArea.find_by_name("stop_na another").should == [@stop_area]
    end

    it "should found twice if matchs partially .. twice" do
      StopArea.find_by_name("stop_na name").should =~ [ @stop_area ]*2
    end

    it "should not raise an error when search string contains a parenthesize or a bracet (#354)" do
      "()[]".each_char do |special_character|
        lambda {
          StopArea.find_by_name(special_character)
        }.should_not raise_error
      end
    end

    it "should ignore parenthesizes" do
      StopArea.find_by_name("stop_name (another").should == [@stop_area]
    end

  end
  
  describe "search by city" do

    before(:each) do
      @city = Factory(:city, :name => "city_name")
      @stop_area = 
        Factory(:stop_area, :name => "stop_name", :countrycode => @city.insee_code)
    end

    it "should not search with stop name" do
      StopArea.find_by_city("stop_name").should be_empty
    end
    
    it "should search with city name" do
      StopArea.find_by_city("city_name").should == [ @stop_area ]
    end
    
    it "should found twice if both name and city name match" do
      StopArea.find_by_city("stop_name city_name").should =~ [@stop_area]*2
    end
    
    it "should found twice if city name matchs and stop area name matchs partially" do
      StopArea.find_by_city("stop_name another_part city_name").should =~ [@stop_area]*2
    end
  end

  describe "itinerary_stops_search" do

    before(:each) do
      @search_string = "dummy"
      @options = { :dummy => true }

      StopArea.stub!(:find_by_city).and_return([])
      StopArea.stub!(:find_by_name).and_return([])
    end

    it "should find by city with specified search string" do
      StopArea.should_receive(:find_by_city).with(@search_string, hash_including(@options))
      StopArea.itinerary_stops_search(@search_string, @options)
    end

    it "should find by name with specified search string" do
      StopArea.should_receive(:find_by_name).with(@search_string, hash_including(@options))
      StopArea.itinerary_stops_search(@search_string, @options)
    end

  end
  
  describe "city relations" do
    it "should find the bound city by insee code using the countrycode" do
      City.should_receive(:find_by_insee_code).with(@stop_area.countrycode.to_i).and_return(city = mock(City))
      @stop_area.city.should == city
    end
  end

  describe "find nearest stop place" do
    
    before(:each) do
      @stop_place = Factory(:stop_area, :areatype => 'StopPlace')
    end

    it "should ignore other type of StopArea" do
      stop_area = Factory(:stop_area, :areatype => 'CommercialStopPoint')
      StopArea.find_nearest_stop_place( stop_area, 1 ).should_not == stop_area
    end

    it "should ignore StopPlace beyond maximum distance" do
      at_2_kms_of_stop_place = @stop_place.endpoint(0, 2)
      StopArea.find_nearest_stop_place( at_2_kms_of_stop_place, 1 ).should be_nil
    end

    it "should find StopPlace if it's near enough" do
      at_500_m_of_stop_place = @stop_place.endpoint(0, 0.5)
      StopArea.find_nearest_stop_place( at_500_m_of_stop_place, 1 ).should == @stop_place
    end

    it "should return nil when specified position isn't completed (missing latitude or longitude)" do
      StopArea.find_nearest_stop_place( Geokit::LatLng.new, 1 ).should be_nil
    end

  end

  describe "commercial children" do
    
    it "should return identifiers with commercial_child_ids" do
      identifiers = (1..3).to_a
      @stop_area.stub!(:commercial_children).and_return do
        identifiers.collect { |n| mock("child", :id => n) }
      end

      @stop_area.commercial_child_ids.should == identifiers
    end

  end

  describe "parent stop place" do
    
    before(:each) do
      @stop_area = Factory(:stop_area)
      @stop_place = Factory(:stop_area, :areatype => "StopPlace")

    end

    it "should return parent if is StopPlace" do
      @stop_area.parent = @stop_place
      @stop_area.parent_stop_place.should == @stop_place
    end

    it "should be nil without parent" do
      @stop_area.parent = nil
      @stop_area.parent_stop_place.should be_nil
    end

    it "should find recursively a StopPlace parent" do
      intermediate_stop_area = Factory(:stop_area, :children => [@stop_area], :parent => @stop_place)
      @stop_area.parent_stop_place.should == @stop_place
    end

  end

end
