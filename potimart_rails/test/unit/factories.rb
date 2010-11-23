# This will guess the StopAreaGeo class
Factory.define :stop_area_geo do |stop_area_geo|
  stop_area_geo.association :stop_area_geo_indicator, :factory => :stop_area_geo
end

# This will guess the Line class
Factory.define :line do |line|
  line.association :line_indicator, :factory => :line
end
