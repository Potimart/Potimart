# -*- coding: utf-8 -*-
Factory.define :stop_area do |s|
  s.name "test_stop_area"
  s.sequence(:id) { |id| id }
  s.latitude 49.65432
  s.longitude 6.1234567
  s.countrycode { |s| s.association(:city).insee_code }
end

Factory.define :city do |c|
  c.name "test_city"
  c.upcase_name "TEST CITY"
  c.sequence(:zip_code) { |n| 9999 + n }
  c.sequence(:insee_code) { |n| 9999 + n }
end

Factory.define :place do |p|
  p.name "test_place"
  p.lat 49.65432
  p.lng 6.1234567
  p.city_code { |p| p.association(:city).zip_code }
end

Factory.define :place_type do
end

Factory.define :road do |f|
  f.name "test_road"
  f.association :city
end
