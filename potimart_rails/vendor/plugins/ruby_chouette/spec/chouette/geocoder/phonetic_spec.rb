# -*- coding: utf-8 -*-
require 'spec_helper'
include Chouette::Geocoder

describe Phonetic do

  it "should return phonetic versions of given word" do
    Phonetic.phonetics("jaurès").should == ["JRS"]
  end

  it "should not return a empty phonetic" do
    Phonetic.phonetics(%w{a b c d e f g h i j k l m n o p q r s t u v w x y z}).should_not include("")
  end
  

end
