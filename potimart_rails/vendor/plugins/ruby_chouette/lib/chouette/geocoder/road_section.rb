module Chouette::Geocoder
  class RoadSection < ChouetteActiveRecord
    belongs_to :road
    belongs_to :ign_route, :class_name => "Chouette::Geocoder::IGN::Route"

    validates_presence_of :road_id, :ign_route_id

    def number_count
      if number_end
        self.number_end - (self.number_begin or 0)
      else
        0
      end
    end

    def relative_position_at(number)
      if number_count > 0
        (number - number_begin) / number_count.to_f
      else
        0.5
      end
    end

    def lat_lng_at(number)
      query = 
        "select astext(line_interpolate_point(the_geom_wgs84,#{relative_position_at(number)})) as point from ign_routes where gid = #{ign_route_id};"
      RoadSection.parse_postgis_point(connection.select_one(query)["point"])
    end

    def to_lat_lng
      lat_lng_at number_begin
    end

    def self.parse_postgis_point(point_definition)
      if point_definition =~ /POINT\(([0-9\.]+) ([0-9\.]+)\)/
        GeoKit::LatLng.normalize("#{$2} #{$1}")  
      end
    end

  end
end
