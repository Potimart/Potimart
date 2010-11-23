require 'spec_helper'
include Chouette::Geocoder

describe IGN::Route do

  before(:each) do
    @route = IGN::Route.new
  end

  describe "left_side" do

    before(:each) do
      @route.nom_rue_g = "dummy"
    end
    
    it "should be the side :g" do
      @route.left_side.side_name.should == :g
    end

    it "should use the parent route" do
      @route.left_side.route.should == @route
    end

    it "should be nil when nom_rue_g is blank" do
      @route.nom_rue_g = ""
      @route.left_side.should be_nil
    end

  end

  describe "right_side" do
    
    before(:each) do
      @route.nom_rue_d = "dummy"
    end
    
    it "should be the side :d" do
      @route.right_side.side_name.should == :d
    end

    it "should use the parent route" do
      @route.right_side.route.should == @route
    end

    it "should be nil when nom_rue_d is blank" do
      @route.nom_rue_d = ""
      @route.right_side.should be_nil
    end

  end

  describe IGN::Route::Side do

    before(:each) do
      @side = IGN::Route::Side.new(@route, :on_given_side)
    end
    
    def self.it_should_use(attribute)
      it "should use #{attribute}_<side name> on Route" do
        @route.stub!("#{attribute}_on_given_side").and_return("dummy")
        @side.send(attribute).should == "dummy"
      end
    end

    it_should_use :nom_rue
    it_should_use :inseecom
    it_should_use :codevoie
    it_should_use :bornedeb
    it_should_use :bornefin

    it "should alias nom_rue as name" do
      # @side.stub!(:name) doesn't work (because of alias_method ?)
      @route.stub!("nom_rue_on_given_side").and_return("nom_rue")
      @side.name.should == "nom_rue"
    end

    it "should use bornedeb and bornefin as number_range" do
      @side.stub!(:bornedeb).and_return(1)
      @side.stub!(:bornefin).and_return(10)
      @side.number_range.should == (1..10)
    end

    it "should be nil if bornedeb or bornefin are invalid" do
      @side.stub!(:bornedeb).and_return(10)
      @side.stub!(:bornefin)

      @side.number_range.should be_nil
    end

  end

  describe "find_each_side" do

    it "should find all existing sides" do
      route = IGN::Route.create :nom_rue_g => "route left name", :nom_rue_d => "route right name" 

      names = []
      IGN::Route.find_each_side do |side|
        side.route.should == route
        names << side.name
      end
      names.should == ["route left name", "route right name"]
    end

  end

end
