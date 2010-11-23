require 'spec_helper'
include Chouette::Geocoder

describe LocationIndex do

  before(:each) do
    @location_index = LocationIndex.new
  end

  def location(attributes = {})
    attributes = { :name => attributes } if String === attributes
    @location = Location.from "dummy", attributes
  end

  it "should find a location when word matchs exactly one of its name" do
    @location_index.push location("word1 word2")
    @location_index.find("word1").should == [ @location ]
  end

  it "should find a location when word starts one of its name" do
    @location_index.push location("word1")
    @location_index.find("word", :match => :begin).should == [ @location ]
  end

  it "should find a location when word matchs exactly phonetically" do
    @location_index.push location(:name => "word", :stored_phonetics => "PHONETIC")
    @location_index.find("PHONETIC", :index => :phonetic).should == [ @location ]
  end

  it "should create a Location if not given" do
    @location_index.push "word"
    @location_index.find("word").should == [ Location.from("word") ]
  end

end
