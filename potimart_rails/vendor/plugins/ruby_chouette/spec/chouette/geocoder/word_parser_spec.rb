# -*- coding: utf-8 -*-
require 'spec_helper'
include Chouette::Geocoder

describe WordParser do

  it "should tokenize given string" do
    WordParser.new("A B C").parts.should == %w{A B C}
  end

  it "should filter parts using given block" do
    word_parser = WordParser.new("A B C")
    word_parser.filter do |part|
      part if part != "B"
    end
    word_parser.parts.should == %w{A C}
  end

  class TestFilter

    def filter(part)
      part == "A" ? "Z" : part
    end

  end

  it "should filter parts using a given filter (with #filter method)" do
    word_parser = WordParser.new("A B C")
    word_parser.filter(TestFilter.new)
    word_parser.parts.should == %w{Z B C}
  end

  it "should remplace part when filter does" do
    WordParser.new("A").filter { |p| "Z" }.parts.should == %w{Z}
  end

  it "should use several parts returned by filter" do
    WordParser.new("A").filter { |p| %w{X Y Z} }.parts.should == %w{X Y Z}
  end

  it "should remove part when filter returns nil" do
    WordParser.new("A").filter { |p| nil }.parts.should be_empty
  end

  it "should transform parts in words" do
    WordParser.new("A", []).words.should == [ "A".to_word ]
  end

  it "should apply filters before creating words" do
    WordParser.new("A", [ TestFilter ]).words.should == [ "Z".to_word ]
  end

  it "should apply default filters by default" do
    WordParser.new("R DE LA QUATRE VINGTIEME STE ROUTE DU XXIEME SIECLE").words.should == "RUE 80 SAINTE ROUTE 21 SIECLE".to_words
  end

  def self.it_should_transform(part, expected_result)
    it "should transform #{part} into #{expected_result}" do
      @filter.filter(part).should == expected_result.to_s
    end
  end

  def self.it_should_not_transform(part)
    it "should not transform #{part}" do
      @filter.filter(part).should == part
    end
  end

  def self.it_should_ignore(part)
    it "should transform #{part}" do
      @filter.filter(part).should be_nil
    end
  end
  
  describe WordParser::OrdinalFilter do

    before(:each) do
      @filter = WordParser::OrdinalFilter.new
    end
    
    it_should_transform "XXIEME", "XXI"
    it_should_transform "1ER", 1
    it_should_transform "16EME", 16
    it_should_transform "89E", 89
    it_should_transform "DEUXIEME", "DEUX"
    it_should_transform "VINGTIEME", "VINGT"

    it_should_not_transform "abc"
    
  end

  describe WordParser::RomanFilter do

    before(:each) do
      @filter = WordParser::RomanFilter.new
    end

    it_should_transform "XVI", 16
    it_should_transform "XXI", 21
    it_should_transform "MCMLXIV", 1964

    it_should_not_transform "MILLE"

  end

  describe WordParser::AbbreviationFilter do

    before(:each) do
      @filter = WordParser::AbbreviationFilter.new
    end

    it_should_transform "ST", "SAINT"
    it_should_transform "STE", "SAINTE"
    it_should_transform "R", "RUE"
    it_should_transform "BD", "BOULEVARD"
    it_should_transform "AV", "AVENUE"
    it_should_transform "FB", "FAUBOURG"
    it_should_transform "MT", "MONT"
    it_should_transform "PTE", "PORTE"
    it_should_transform "GAL", "GENERAL"

    it_should_not_transform "RUELLE"

  end

  describe WordParser::StopWordFilter do
    
    before(:each) do
      @filter = WordParser::StopWordFilter.new
    end

    it_should_ignore "LE"
    it_should_ignore "LA"
    it_should_ignore "DE"
    it_should_ignore "ET"

    it_should_not_transform "UN"
    it_should_not_transform "R"

  end

  describe WordParser::TextNumberFilter do
    
    before(:each) do
      @filter = WordParser::TextNumberFilter.new
    end

    def self.it_should_transform(parts, expected_result)
      it "should transform '#{parts}' into #{expected_result}" do
        WordParser.new(parts).filter(@filter).parts.join(' ').should == expected_result.to_s
      end
    end

    it_should_transform "DEUX", 2
    it_should_transform "VINGT DEUX", 22
    it_should_transform "QUATRE VINGT", 80
    it_should_transform "CENTS", 100
    it_should_transform "MILLES", 1000
    it_should_transform "DEUX CENTS", 200
    it_should_transform "DEUX MILLES", 2000

    it_should_transform "MILLE NEUF CENT QUATRE-VINGT DIX SEPT", 1997
    it_should_transform "MILLE CENT VINGT", 1120

    it_should_transform "MOT DEUX", "MOT 2"
    it_should_transform "MOT DEUX MOT VINGT DEUX MOT", "MOT 2 MOT 22 MOT"

    describe "text_number?" do

      it "should be true for 'VINGT'" do
        WordParser::TextNumberFilter.text_number?("VINGT").should be_true
      end

      it "should be true for 'MILLES'" do
        WordParser::TextNumberFilter.text_number?("MILLES").should be_true
      end

      it "should be false for 'ABC'" do
        WordParser::TextNumberFilter.text_number?("ABC").should be_false
      end
      
    end

  end


end
