require 'spec_helper'
include Chouette::Geocoder

describe Road do

  before(:each) do
    @road = Road.new :name => "dummy", :city => Factory(:city)
  end

  it "should validate name is not blank" do
    @road.name = ""
    @road.should have(1).error_on(:name)
  end

  it "should validate a city is associated" do
    @road.city = nil
    @road.should have(1).error_on(:city_id)
  end

  describe "section_at" do

    before(:each) do
      @road.save!

      @section_5_15 = @road.sections.create! :number_begin => 5, :number_end => 15, :ign_route_id => 1
      @section_18_31 = @road.sections.create! :number_begin => 18, :number_end => 31, :ign_route_id => 1
    end
    
    it "should return section with contains this number" do
      @road.section_at(20).should == @section_18_31
    end

  end

  describe "number at half street" do
    
    it "should return 15 when road goes from 10 to 20" do
      @road.number_begin = 10
      @road.number_end = 20
      @road.number_at_half_street.should == 15
    end

  end

  it "should have number_range with number_begin and number_end" do
    @road.number_begin = 1
    @road.number_end = 10
    @road.number_range.should == (1..10)
  end

  describe "create_all" do

    before(:each) do
      @city = Factory(:city)
    end

    it "should create Road with side name" do
      IGN::Route.create(:nom_rue_g => "first", :inseecom_g => @city.insee_code)
      Road.create_all
      Road.first.name.should == "first"
    end

    it "should assign road_id in IGN::Route" do
      route = IGN::Route.create(:nom_rue_g => "first", :inseecom_g => @city.insee_code)
      Road.create_all
      route.reload.roads.should == Road.all
    end

    it "should create Road with the city associated to the side insee code" do
      IGN::Route.create(:nom_rue_g => "first", :inseecom_g => @city.insee_code)
      Road.create_all
      Road.first.city.should == @city
    end

    it "should not create Road when insee code is unknown" do
      IGN::Route.create(:inseecom_g => "dummy")
      Road.create_all
      Road.count.should be_zero
    end

    it "should not create Road when name is empty" do
      IGN::Route.create(:nom_rue_g => nil, :inseecom_g => @city.insee_code)
      Road.create_all
      Road.count.should be_zero
    end

    it "should not create two Road with the same name in a city" do
      IGN::Route.create(:nom_rue_g => "first", :inseecom_g => @city.insee_code)
      IGN::Route.create(:nom_rue_d => "first", :inseecom_g => @city.insee_code)
      Road.create_all
      Road.count.should == 1
    end

    it "should use side bornedeb and bornefin for Road number range" do
      IGN::Route.create(:nom_rue_g => "first", :inseecom_g => @city.insee_code, :bornedeb_g => 1, :bornefin_g => 30)
      Road.create_all
      Road.first.number_range.should == (1..30)
    end

    it "should use numbers of all sides for Road number range" do
      IGN::Route.create(:nom_rue_g => "first", :inseecom_g => @city.insee_code, :bornedeb_g => 1, :bornefin_g => 17)
      IGN::Route.create(:nom_rue_d => "first", :inseecom_d => @city.insee_code, :bornedeb_d => 2, :bornefin_d => 30)
      Road.create_all
      Road.first.number_range.should == (1..30)
    end

    it "should create a single section for a IGN::Route at the same Road" do
      IGN::Route.create(:nom_rue_g => "first", :inseecom_g => @city.insee_code, :bornedeb_g => 1, :bornefin_g => 17, :nom_rue_d => "first", :inseecom_d => @city.insee_code, :bornedeb_d => 2, :bornefin_d => 30)
      Road.create_all
      Road.first.sections.should be_one
    end

  end

end

describe Road::Builder do

  before(:each) do
    @builder = Road::Builder.new
  end
  
  it "should be empty by default" do
    @builder.should be_empty
  end

  it "should not be empty when raw_name and city_id are defined" do
    @builder.raw_name = "dummy"
    @builder.city_id = 1

    @builder.should_not be_empty
  end

end
