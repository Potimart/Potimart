# -*- coding: utf-8 -*-
require File.join(File.dirname(__FILE__),'../spec_helper')

describe Place do
  
  it "should act as mappable" do
    Place.should respond_to(:acts_as_mappable)
  end

  describe "search by city" do

    before(:each) do
      @place = Factory(:place)
      Factory(:stop_area, :countrycode => @place.city.insee_code)
    end

    it "should find place when city name matchs" do
      Place.find_by_city(@place.city.name).should == [@place]
    end

    it "should find twice the place when place name and the city name match" do
      Place.find_by_city("#{@place.city.name} #{@place.name}").should == [@place]*2
    end

    it "should not find place if no stop area in the city" do
      @place.city.stop_areas.each(&:destroy)
      Place.find_by_city(@place.city.name).should be_empty
    end
    
    # FIXME : AreaSearch.find_by_city hasn't a such logic
    # it "shoud filter if no stop area bound to place" do
    #   Place.find_by_city("tours").select { |s| 
    #     s.id == @place.id
    #   }.size.should == 0
    # end
  end

  describe "itinerary_stops_search" do

    before(:each) do
      @search_string = "dummy"
    end
    
    it "should find by cities with search string" do
      Place.should_receive(:find_by_city).with(@search_string, anything).and_return([])
      Place.itinerary_stops_search(@search_string)
    end

    it "should find by cities with specified options" do
      options = { :conditions => {} }
      Place.should_receive(:find_by_city).with(anything, options).and_return([])
      Place.itinerary_stops_search(@search_string, options)
    end

    it "should find by name with search string" do
      Place.should_receive(:find_by_name).with(@search_string, anything).and_return([])
      Place.itinerary_stops_search(@search_string)
    end

    it "should find by name with specified options" do
      options = { :conditions => {} }
      Place.should_receive(:find_by_name).with(anything, options).and_return([])
      Place.itinerary_stops_search(@search_string, options)
    end

    it "should transform latitude/longitude conditions into lat/lng" do
      options_with_fullname = { :conditions => { :latitude => 1, :longitude => 1 } }
      options_with_shortname = { :conditions => { :lat => 1, :lng => 1 } }
      
      Place.should_receive(:find_by_city).with(anything, options_with_shortname).and_return([])
      Place.should_receive(:find_by_name).with(anything, options_with_shortname).and_return([])

      Place.itinerary_stops_search(@search_string, options_with_fullname)
    end
    
  end
  
end
