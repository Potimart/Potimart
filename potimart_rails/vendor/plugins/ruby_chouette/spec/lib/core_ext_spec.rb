# -*- coding: utf-8 -*-
require File.join(File.dirname(__FILE__),'/../spec_helper')

describe Hash do

  before(:each) do
    @initial_key = "old"
    @new_key = "new"
    @renaming = { @initial_key => @new_key }

    @value= "dummy"
    @hash = { @initial_key => @value }
  end
  
  describe "rename_key!" do
    
    it "should delete the old key" do
      @hash.rename_key!(@initial_key, @new_key)
      @hash.should_not have_key(@initial_key)
    end

    it "should reassign the value with the new key" do
      @hash.rename_key!(@initial_key, @new_key)
      @hash[@new_key].should == @value
    end

    it "should be a reversable operation" do
      initial_hash = @hash.dup
      @hash.rename_key!(@initial_key, @new_key)
      @hash.rename_key!(@new_key, @initial_key)
      @hash.should == initial_hash
    end

    it "should return the hash" do
      @hash.rename_key!(@initial_key, @new_key).should == @hash
    end

  end

  describe "rename_keys!" do

    it "should rename using each pair of the given map as old/new keys" do
      @hash.should_receive(:rename_key!).with(@initial_key, @new_key)
      @hash.rename_keys!(@initial_key => @new_key)
    end

    it "should return the hash" do
      @hash.rename_keys!(@renaming).should == @hash
    end

  end

  describe "rename_keys" do

    before(:each) do
      @duplicate = @hash.dup
      @hash.stub!(:dup).and_return(@duplicate)
    end
    
    it "should rename keys of a duplicate" do
      @duplicate.should_receive(:rename_keys!).with(@renaming).and_return(@duplicate)
      @hash.rename_keys(@renaming)
    end

    it "should return the duplicate" do
      @hash.rename_keys(@renaming).should == @duplicate
    end

  end

end
