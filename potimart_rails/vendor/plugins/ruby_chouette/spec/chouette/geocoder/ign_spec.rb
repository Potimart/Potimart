require 'spec_helper'
include Chouette::Geocoder

describe IGN, "resolve_ign_abbreviation" do

  it "should resolve ign abbreviation NTE into 'NOUVELLE ROUTE'" do
    IGN.resolve_abbreviation('NTE').should == "NOUVELLE ROUTE"
  end
  
  it "should resolve ign abbreviation 'IMP DE MONTREUIL' into 'IMPASSE DE MONTREUIL'" do
    IGN.resolve_abbreviation('IMP DE MONTREUIL').should == "IMPASSE DE MONTREUIL"
  end

end
