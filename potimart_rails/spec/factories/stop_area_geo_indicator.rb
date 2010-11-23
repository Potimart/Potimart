# Defines a new sequence
Factory.sequence :name do |n|
  "Indicator#{n}"
end

Factory.define :stop_area_geo_indicator do |stop_area_geo_indicator|
  stop_area_geo_indicator.name { Factory.next(:name) }
  stop_area_geo_indicator.value  2
  stop_area_geo_indicator.association :stop_area_geo_id, :factory => :stop_area_geo
end
