require 'spec_helper'
include Chouette::Geocoder

describe ScoreBoard do

  before(:each) do
    @score_board = ScoreBoard.new
    @scoring = Scoring.new("dummy")
  end

  it "should have a maximum size of 30 by default" do
    ScoreBoard.new.maximum_size.should == 30
  end

  it "should be empty at creation" do
    @score_board.should be_empty
  end

  it "should enumerate pushed scorings" do
    @score_board.push @scoring
    @score_board.to_a.should include(@scoring)
  end
  
  it "should not include twice a scoring" do
    @score_board.stub!(:include?).and_return(true)
    @score_board.push @scoring
    @score_board.should be_empty
  end

  it "should include scoring when uid is known" do
    @score_board.push @scoring
    @score_board.should include(mock(Scoring, :uid => @scoring.uid))
  end

  it "should not include more than maximum_size scorings" do
    (@score_board.maximum_size + 10).times do |n|
      @score_board.push Scoring.new("location#{n}")
    end
    @score_board.size.should == @score_board.maximum_size
  end

  it "should be full when maximum_size is reached" do
    (@score_board.maximum_size + 1).times do |n|
      @score_board.push Scoring.new("location#{n}")
    end
    @score_board.should be_full
  end

  it "should order scoring by score" do
    (@score_board.maximum_size + 1).times do |n|
      @score_board.push Scoring.new("location#{n}").tap { |s| s.score = n }
    end
   
    @score_board.collect(&:score).should == (1..30).to_a.reverse
  end

end
