require 'spec_helper'
include Chouette::Geocoder

describe Scoring do

  it "should have a null score when created" do
    Scoring.new("location").score.should be_zero
  end

  it "should use the given location" do
    location = Location.from("location")
    Scoring.new(location).location.should == location
  end

  it "should create a Location if needed" do
    Scoring.new("location").location.should == Location.from("location")
  end

  it "should display location and score in to_s" do
    Scoring.new("location").to_s.should == "location (0)"
  end

end
