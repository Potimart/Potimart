# -*- coding: utf-8 -*-
require File.join(File.dirname(__FILE__),'../spec_helper')

describe City do

  describe "find_by_name" do
    
    it "should not raise an error when a parenthesize is given" do
      "()[]".each_char do |special_character|
        lambda { City.find_by_name("dummy #{special_character} dummy", nil) }.should_not raise_error
      end
    end

  end

end
