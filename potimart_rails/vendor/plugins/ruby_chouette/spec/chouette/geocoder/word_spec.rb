# -*- coding: utf-8 -*-
require 'spec_helper'
include Chouette::Geocoder

describe Word do

  before(:each) do
    @word = "A".to_word
  end

  it "should return word:<string> for inspect" do
    @word.inspect.should == "word:A"
  end

  describe "to_word" do
    
    it "should return self" do
      @word.to_word.should == @word
    end

  end

  describe "String#to_word" do

    it "should invoke Word.to_word method" do
      Word.should_receive(:to_word).with("ABC")
      "ABC".to_word
    end
    
    it "should return the word created from the string" do
      "ABC".to_word.should == Word.to_word("ABC")
    end

  end

  describe "String#to_words" do

    it "should invoke Word.to_words method" do
      Word.should_receive(:to_words).with("A B C")
      "A B C".to_words
    end
    
    it "should return the words created from the string" do
      "A B C".to_words.should == Word.to_words("A B C")
    end

  end

  describe "Array#to_words" do
    
    it "should collect words" do
      word_a = "A".to_word
      [ mock("A", :to_word => word_a) ].to_words.should == [word_a]
    end

  end

  describe "class method" do

    describe "to_word" do

      before(:each) do
        Word.clear_instances
        @token = Token.token("ABC")
      end
      
      it "should create a token with given input" do
        Token.should_receive(:token).with("ABC").and_return(@token)
        Word.to_word("ABC")
      end

      it "should create a word from token" do
        Token.stub!(:token).and_return(@token)

        word = mock(Word)
        Word.should_receive(:new).with(@token).and_return(word)

        Word.to_word("ABC").should == word
      end

    end
    
    describe "to_words" do
      
      it "should use a WordParser for a string" do
        WordParser.should_receive(:new).with("A B C").and_return(mock(WordParser, :words => [@word]))
        Word.to_words("A B C").should == [@word]
      end

      it "should tranform elements in words" do
        Word.to_words([@word, "A"]).should == [@word, "A".to_word]
      end

    end
    
  end

  describe "match" do
    
    it "should return 0 if the given string doesn't start with word" do
      "A".to_word.match("DUMMY").should == 0
    end

    it "should return 1 if the given string is the word" do
      "ABC".to_word.match("ABC").should == 1
    end

    it "should return the rate of matching letters when the given string start with word" do
      "A".to_word.match("ABC").should == 1/3.0
    end

  end

end
