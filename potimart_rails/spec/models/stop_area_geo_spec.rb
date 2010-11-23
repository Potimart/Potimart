require 'spec_helper'

describe StopAreaGeo do
  before(:each) do
    @valid_attributes = {
      :name => "value for name",
      :stoparea_id => 1
    }
  end

  it "should create a new instance given valid attributes" do
    StopAreaGeo.create!(@valid_attributes)
  end
end
