# -*- coding: utf-8 -*-
require File.join(File.dirname(__FILE__),'../spec_helper')

describe PlaceType do
  
  before(:each) do
    @place_type_a = Factory(:place_type, :name => "a")
    @place_type_b = Factory(:place_type, :name => "b")
    @place_type_c = Factory(:place_type, :name => "c")
  end

  describe "named scopes " do

    it "include_names should find all matching names" do
      PlaceType.include_names(["a","b"]).should == [@place_type_a,@place_type_b]
    end

    it "exclude_names should exclude all matching names" do
      PlaceType.exclude_names(["a"]).should_not be_include @place_type_a
    end

    
  end

  
end
