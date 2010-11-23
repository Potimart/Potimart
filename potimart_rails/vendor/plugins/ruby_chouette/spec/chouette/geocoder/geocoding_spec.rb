require 'spec_helper'
include Chouette::Geocoder

describe Geocoding do

  before(:each) do
    @geocoding = Geocoding.new("word1 word2 token1")
    Geocoding.default_location_index = nil
  end

  after(:each) do
    Geocoding.default_location_index = nil
  end

  it "should use default_location_index as location_index" do
    Geocoding.default_location_index = mock("LocationIndex")
    Geocoding.new("").location_index.should == Geocoding.default_location_index
  end

  describe "input_tokens" do

    before(:each) do
      @tokens = Token.tokenize(@geocoding.input_string)
    end
    
    it "should tokenize input string" do
      Token.should_receive(:tokenize).with(@geocoding.input_string).and_return(@tokens)
      @geocoding.input_tokens.should == @tokens
    end

    it "should keep in cache tokens" do
      @geocoding.input_tokens
      Token.should_not_receive(:tokenize)
      @geocoding.input_tokens
    end

  end

  describe "last_token" do
    
    it "should be the last input token" do
      @geocoding.stub!(:input_tokens).and_return(%w{token1 token2})
      @geocoding.last_token.should == "token2"
    end

    it "should be nil when input tokens is empty" do
      @geocoding.stub!(:input_tokens).and_return([])
      @geocoding.last_token.should be_nil
    end

  end

  describe "input_words" do

    it "should return words from input tokens, except the last one" do
      useful_tokens = @geocoding.input_tokens
      @geocoding.stub!(:input_tokens).and_return(useful_tokens + Token.tokenize("dummy"))
      
      @geocoding.input_words.should == useful_tokens.to_words
    end
    
  end

  describe "street_number" do
    
    it "should use the first input token if numerical" do
      Geocoding.new("1 token1").street_number.should == 1
    end

    it "should be nil if no found" do
      Geocoding.new("token1 token2").street_number.should be_nil
    end

    it "should be nil if input is empty" do
      @geocoding.stub!(:input_tokens).and_return([])
      @geocoding.street_number.should be_nil
    end

  end

  describe "locations" do

    def geocoding(search, &block)
      Geocoding.new(search).tap do |geocoding|
        yield geocoding.location_index
      end
    end

    def location(attributes = {})
      @location = Location.from("location", attributes)
    end

    it "should be empty without input" do
      Geocoding.new("").locations.should be_empty
    end

    it "should be an object when a word matchs exactly" do
      geocoding("word1 last_token") do |index|
        index.push location(:name => "WORD1")
      end.locations.should == [@location]
    end

    it "should be not find an object twice" do
      geocoding("word1 word2") do |index|
        index.push location(:name => "WORD1 WORD2")
      end.locations.should == [@location]
    end

    it "should be an object when a word matchs the beginning" do
      geocoding("begin last_token") do |index|
        index.push location(:name => "BEGINOFTHEWORD")
      end.locations.should == [@location]
    end

    it "should try to find a partial match for the last token" do
      geocoding("word1 begin") do |index|
        index.push location(:name => "BEGINOFTHEWORD")
      end.locations.should == [@location]
    end
    
  end

  describe "references" do

    before(:each) do
      @locations = Array.new(3) do |n| 
        mock(Location, :reference => "reference-#{n}") 
      end
      @geocoding.stub!(:locations).and_return(@locations)

      @references = @locations.collect(&:reference)
      Location.stub!(:references).and_return(@references)
    end
    
    it "should find locations with their references" do
      Location.should_receive(:references).with(@locations).and_return(@references)
      @geocoding.references
    end

    it "should return references associated to locations" do
      @geocoding.references.should == @references
    end

    it "should replace Road references with Address ones" do
      @geocoding.stub!(:street_number).and_return(12)
      Location.stub!(:references).and_return [ road = Road.new ]

      @geocoding.references.should == [ Address.new(road, 12) ]
    end

  end

end

describe Geocoding::Task do

  before(:each) do
    @geocoding = mock Geocoding
    @task = Geocoding::Task.new(@geocoding, "word1", :dummy => true)
    
    @locations = Array.new(3) { |n| "location-#{n}" }
  end
  
  it "should load locations in given location index" do
    @task.stub!(:location_index).and_return(mock(LocationIndex))
    @task.location_index.should_receive(:find).with(@task.input, @task.options).and_return(@locations)

    @task.locations.should == @locations
  end

  it "should score each location when running" do
    @task.stub!(:locations).and_return(@locations)

    @locations.each { |l| @task.should_receive(:score).with(l) }
    @task.run
  end

  it "should use location count as cost" do
    @task.stub!(:location_index).and_return(mock(LocationIndex))
    @task.location_index.should_receive(:count).with(@task.input, @task.options).and_return(4)
    
    @task.cost.should == 4
  end

end
