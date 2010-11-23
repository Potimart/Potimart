require 'spec_helper'
include Chouette::Geocoder

describe WordIndex do

  before(:each) do
    @word = "A".to_word
    @word_index = WordIndex.new

    @object = mock("object")
  end

  it "should retrieve a pushed object with the same word" do
    @word_index.push @word, @object
    @word_index.get(@word).should == [ @object ]
  end

  it "should return nil when nothing is associated to the word" do
    @word_index.get("dummy").should be_nil
  end

  it "should support several objects associated to the same word" do
    @word_index.push(@word, object1 = mock("object1"))
    @word_index.push(@word, object2 = mock("object2"))

    @word_index.get(@word).should == [ object1, object2 ]
  end

  it "should accept several words associated to the object" do
    another_word = "B".to_word
    @word_index.push [@word, another_word], @object

    @word_index.get(@word).should == [@object]    
    @word_index.get(another_word).should == [@object]
  end

  describe "start_with" do
    
    it "should collect objects associated to keys which start with specified string" do
      @word_index.push "ABC", @object
      @word_index.start_with("A").should == [ @object ]
    end

  end

  describe "get" do 

    it "should return objects associated to the given word" do
      @word_index.push "ABC", @object
      @word_index.get("ABC").should == [ @object ]
    end

  end

end
