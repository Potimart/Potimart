require 'spec_helper'
include Chouette::Geocoder

describe WordSetMatcher do

  describe "match_words" do

    it "should use word matching" do
      WordSetMatcher.new("word", "word1").score.should == "word".to_word.match("word1".to_word)
    end
    
    it "should add words matching" do
      WordSetMatcher.new("word1 word2", "word1 word2").score.should == 2
    end

    it "should not count twice the same word" do
      WordSetMatcher.new("word", "word1 word2").score.should <= 1
    end
    
  end

end
