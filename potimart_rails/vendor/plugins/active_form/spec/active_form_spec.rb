require File.dirname(__FILE__) + '/spec_helper'

describe ActiveForm do

  before(:each) do
    @active_form = ActiveForm::Base.new
  end

  describe "id" do

    it { @active_form.id.should be_nil }
    
  end

  describe "self_and_descendents_from_active_record" do

    class TestClass < ActiveForm::Base
    end

    class TestSubClass < TestClass
    end

    it "should return class if simply inherited from ActiveForm" do
      TestClass.self_and_descendents_from_active_record.should == [ TestClass ]
    end

    it "should return class and super classes until base class" do
      TestSubClass.self_and_descendents_from_active_record.should == [ TestSubClass, TestClass ]
    end

  end

  describe "multiparameter attributes" do

    class WithMultiParameter < ActiveForm::Base
      attr_accessor :created_at
    end

    before(:each) do
      @active_form = WithMultiParameter.new
    end
    
    it "should update attribute with multiparts" do
      multipart_attributes = {
        "created_at(1i)"=>"2009", 
        "created_at(2i)"=>"3", 
        "created_at(3i)"=>"4", 
        "created_at(4i)"=>"19",
        "created_at(5i)"=>"29"
      }
      @active_form.attributes = multipart_attributes
      @active_form.created_at.should == Time.local(2009, 3, 4, 19, 29)
    end

  end

  it "should invoke after_initialize method (if exists) when created" do
    class WithAfterInitialize < ActiveForm::Base
      attr_accessor :after_initialize_called
      private
      def after_initialize
        self.after_initialize_called = true
      end
    end

    @active_form = WithAfterInitialize.new
    @active_form.after_initialize_called.should be_true
  end

  it "should be always a new record" do
    @active_form.should be_new_record
  end

  describe "update_attributes" do
    
    it "should set specified attributes" do
      attributes = { :dummy => true }
      @active_form.should_receive(:attributes=).with(attributes)
      @active_form.update_attributes(attributes)
    end

  end

  describe "attribute alias" do


    class WithAttrAlias < ActiveForm::Base
      attr_accessor :original
      attr_alias :alias, :original
    end

    before(:each) do
      @active_form = WithAttrAlias.new 
    end

    it "should return same value than orginal attribute" do
      @active_form.original = 'dummy'
      @active_form.alias.should == @active_form.original
    end

    it "should return change the same value than orginal attribute" do
      @active_form.alias = "dummy"
      @active_form.original.should == @active_form.alias
    end

  end

  describe "attribute_names" do
    
    class WithFewAttributes < ActiveForm::Base
      attr_accessor :first, :another
      attr_alias :alias, :first
    end

    before(:each) do
      @active_form_class = WithFewAttributes
    end

    it "should return names of attributes defined with attr_accessor" do
      @active_form_class.attribute_names.should == [ "first", "another" ]
    end

    it "should ignore attribute alias" do
      @active_form_class.attribute_names.should_not include("alias")
    end

  end
  
end
