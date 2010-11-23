# -*- coding: utf-8 -*-
require 'spec_helper'
include Chouette::Geocoder

describe Token do

  def token(string)
    return string if Token == string
    Token.tokenize(string).first
  end

  it "should return token:<string> for inspect" do
    token("string").inspect.should == "token:STRING"
  end

  it "should be equal to a word with the same string" do
    token = token("string")
    word = "string".to_word

    token.should == word
    word.should == token
  end

  describe "tokenize" do

    def be_tokenized_into(token_string)
      simple_matcher("tokenized into '#{token_string}'") do |actual|
        token(actual).to_s == token_string
      end
      
    end
    
    it "should keep upcase letters" do
      "ABC".should be_tokenized_into("ABC")
    end

    it "should keep numbers" do
      "123".should be_tokenized_into("123")
    end

    it "should upcase downcase letters" do
      "abc".should be_tokenized_into("ABC")
    end

    def self.it_should_replace_character(characters, target)
      character_count = characters.size / 2 # UTF8
      it "should replace characters #{characters} with #{target}" do
        characters.should be_tokenized_into(target * character_count)
      end
    end

    it_should_replace_character "âà", "A"
    it_should_replace_character "êèéë", "E"
    it_should_replace_character "îï", "I"
    it_should_replace_character "ôö", "O"
    it_should_replace_character "ûùü", "U"
    it_should_replace_character "ç", "C"

    it "should ignore dots" do
      "A.B.C.".should be_tokenized_into("ABC")
    end

    it "should return a token array" do
      Token.tokenize("A").should == [ token("A") ]  
    end

    it "should split whitespaces" do
      Token.tokenize("A B").should == [ token("A"), token("B") ]
    end

    it "should split unsupported characters" do
      Token.tokenize("A:B").should == [ token("A"), token("B") ]
    end

  end

  describe "token" do
    
    it "should transform a string into a single token" do
      Token.token("A").should == token("A")
    end

    it "should raise an error when several tokens are found" do
      lambda { Token.token("A B") }.should raise_error
    end

    it "should return a given token" do
      token = token("A")
      Token.token(token).should == token
    end

  end

end
