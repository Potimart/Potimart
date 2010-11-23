require 'spec_helper'
include Chouette::Geocoder

describe Location do

  before(:each) do
    @location = Location.new :name => "dummy"
    @zone = mock(Zone)
  end

  it "should use the reference hash if not an ActiveRecord" do
    Location.from("dummy").uid.should == "dummy".hash
  end

  it "should use the hash of reference_type and id" do
    road = Factory(:road)
    Location.from(road).uid.should == "Chouette::Geocoder::Road:#{road.id}".hash
  end

  it "should use the given name" do
    Location.from("dummy", :name => "given name").name.should == "given name"
  end

  it "should the reference name if available" do
    reference = mock("reference", :name => "reference name")
    Location.from(reference).name.should == "reference name"
  end

  it "should transform the name into words if none given" do
    Location.from("name").words.should == "name".to_words
  end

  describe "references" do

    before(:each) do
      @locations = Array.new(3) do |n| 
        mock(Location, :reference => "reference-#{n}") 
      end
      Location.stub!(:find).and_return(@locations)
      @references = @locations.collect(&:reference)
    end
    
    it "should find locations with their references" do
      Location.should_receive(:find).with(@locations, :include => "reference").and_return(@locations)
      Location.references(@locations)
    end

    it "should return references associated to locations" do
      Location.references(@locations).should == @references
    end

    it "should return references in the same order than locations" do
      Location.stub!(:find).and_return(@locations.reverse)
      Location.references(@locations).should == @references
    end

  end

end
