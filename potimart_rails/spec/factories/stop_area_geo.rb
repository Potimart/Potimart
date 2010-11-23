# Defines a new sequence
Factory.sequence :name do |n|
  "StopAreaGeo#{n}"
end

Factory.define :stop_area_geo do |stop_area_geo|
  stop_area_geo.name { Factory.next(:name) }
end