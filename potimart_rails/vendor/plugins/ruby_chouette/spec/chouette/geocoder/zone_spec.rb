# -*- coding: utf-8 -*-
require 'spec_helper'
include Chouette::Geocoder

describe Zone do

  before(:each) do
    @zone = Zone.new
    @insee_code = 1234
  end

  it "should transform name into words (by ignoring stop words)" do
    @zone.name = "Bézu-le-Guéry"
    @zone.words.should == %w{BEZU GUERY}.to_words
  end

  it "should be equal with another Zone with the same uid" do
    Zone.new(:uid => 1).should == Zone.new(:uid => 1)
  end

  it "should store words" do
    @zone.stub!(:words).and_return("B E".to_words)
    @zone.save!
    @zone.stored_words.should == "B E"
  end

  it "should reload words without using name" do
    @zone.stub!(:words).and_return("A B".to_words)
    @zone.save!
    @zone = Zone.find(@zone.id)

    @zone.stub!(:name)
    @zone.words.should == "A B".to_words
  end

  describe "class method find_by_insee_code" do

    before(:each) do
      @city = mock(City, :name => "name", :insee_code => @insee_code)
      City.stub!(:find_by_insee_code).and_return(@city)
    end

    it "should find the associated city (according the insee code)" do
      City.should_receive(:find_by_insee_code).with(@insee_code).and_return(@city)
      Zone.find_by_insee(@insee_code).uid.should == @city.insee_code
    end

    it "should use the City name" do
      Zone.find_by_insee(@insee_code).name.should == @city.name
    end
    
  end

  describe "class method find_by_city" do
    
    before(:each) do
      @city = mock(City, :name => "name", :insee_code => @insee_code)
    end

    it "should return nil if given insee code is nil" do
      Zone.find_by_city(nil).should be_nil
    end

    it "should return a Zone with City name" do
      Zone.find_by_city(@city).name.should == @city.name
    end

    it "should return a Zone with City insee code as uid" do
      Zone.find_by_city(@city).uid.should == @city.insee_code
    end

  end

end
