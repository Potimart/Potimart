def location_index
  @location_index ||= Chouette::Geocoder::LocationIndex.new
end

def push_location(location, label = nil)
  location_index.push location
  if label == "the"
    @that_location = location
  end
end

Given /^(.*) location "([^\"]*)" exists$/ do |label, location|
  push_location Chouette::Geocoder::Location.from(location), label
end

Given /^(.*) location "([^\"]*)" exists in "([^\"]*)"$/ do |label, name, zone|
  push_location Chouette::Geocoder::Location.from(name, :zone => Chouette::Geocoder::Zone.new(:name => zone)), label
end

When /^I search "([^\"]*)"$/ do |search|
  @geocoding = Chouette::Geocoder::Geocoding.new search, :location_index => location_index
end

Then /^that location should be selected$/ do
  @geocoding.locations.should include(@that_location)
end

Then /^that location should not be selected$/ do
  @geocoding.locations.should_not include(@that_location)
end

Then /^that location should be selected first$/ do
  @geocoding.locations.first.should == @that_location
end

Then /^show me the scoreboard$/ do
  puts "scoreboard for #{@geocoding.input_string}"
  puts @geocoding.score_board.collect(&:to_s).join("\n")
end
