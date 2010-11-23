# -*- coding: utf-8 -*-
require 'spec_helper'
include Chouette::Geocoder

describe StringContainer do

  def container(string)
    return string if Token == string
    Token.tokenize(string).first
  end

  describe "<=>" do
    
    it "should compare the two strings" do
      container("A").should < container("B")
    end

    it "should accept a string" do
      container("A").should < "B"
    end

  end

end
