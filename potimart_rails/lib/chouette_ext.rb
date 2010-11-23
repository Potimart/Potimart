class JourneyPattern

  def positions
    @positions ||= ChouetteActiveRecord.connection.select_all("SELECT DISTINCT
  vehiclejourney.journeypatternid AS journeypattern_id,
  stoparea.id AS stoparea_id,
  stoparea.name AS stoparea_name,
  stoparea.longitude AS stoparea_longitude,
  stoparea.latitude AS stoparea_latitude,
  stoparea.longlattype AS stoparea_coordinates_type,
  stoppoint.position AS stoppoint_position,
  line.id AS line_id,
  line.name AS line_name
FROM
  vehiclejourney,
  vehiclejourneyatstop,
  stoppoint,
  stoparea,
  line,
  route
WHERE
  vehiclejourney.journeypatternid = #{id} AND
  vehiclejourneyatstop.vehiclejourneyid = vehiclejourney.id AND
  stoppoint.id = vehiclejourneyatstop.stoppointid AND
  stoppoint.stopareaid = stoparea.id AND
  route.id = vehiclejourney.routeid AND
  line.id = route.lineid
ORDER BY
  stoppoint.position ASC;").collect do |attributes|
      Position.new(attributes)
    end
    return @positions
  end

end

class Position

  # Create get and set methods
  attr_accessor :line_id, :line_name, :journeypattern_id, :stoparea_id, :stoparea_name, :stoparea_longitude,
    :stoparea_latitude, :stoparea_coordinates_type, :stoppoint_position

  def stoparea_longitude=(stoparea_longitude)
    @stoparea_longitude=stoparea_longitude.to_f
  end

  def stoparea_latitude=(stoparea_latitude)
    @stoparea_latitude=stoparea_latitude.to_f
  end

  def stoppoint_position=(stoppoint_position)
    @stoppoint_position=stoppoint_position.to_i
  end

  def to_lat_lng
    GeoKit::LatLng.new stoparea_latitude, stoparea_longitude
  end

  def initialize(attributes)
    attributes.each { |k,v| send("#{k}=", v) }
  end
end