require 'ostruct'
# id bigint NOT NULL,
# lineid bigint,
# objectid character varying(255),
# objectversion integer,
# creationtime timestamp without time zone,
# creatorid character varying(255),
# publishedjourneyname character varying(255),
# publishedjourneyidentifier character varying(255),
# transportmode character varying(255),
# vehicletypeidentifier character varying(255),
# statusvalue character varying(255),
# facility character varying(255),
# number integer,
# "comment" character varying(255),


class VehicleJourney < ChouetteActiveRecord
  set_table_name :vehiclejourney
  belongs_to :route, :class_name => "Route", :foreign_key => "routeid"
  belongs_to :creator, :class_name => "User", :foreign_key => "creatorid"
  has_many :time_table_vehicle_journeys, :class_name => "TimeTableVehicleJourney", :foreign_key => "vehiclejourneyid"
  has_many :time_tables, :class_name => "TimeTable", :through => :time_table_vehicle_journeys
  has_many :stop_points, :class_name => "StopPoint", :through => :vehicle_journey_at_stops
  belongs_to :journey_pattern, :foreign_key => "journeypatternid"
  has_many :vehicle_journey_at_stops, :class_name => "VehicleJourneyAtStop", :foreign_key => "vehiclejourneyid", :order => "departuretime" do
    def after(stop_point)
      find(:all).select { |stop| stop.stop_point.position >= stop_point.position }
    end
    
    def last
      find(:all).sort_by { |vjas| vjas.stop_point.position }.last
    end
  end

  def get_direction_name
    get_direction["name"]
  end
  
  def get_direction_id
    get_direction["id"]
  end

  def stop_point_index(stop_point_id)
    jpsps = JourneyPatternStopPoint.select_journey_pattern( self.journeypatternid)
    selected_stops = jpsps.select { |jpsp| jpsp.stop_point_id == stop_point_id.to_i}
    if (selected_stops.nil? || selected_stops.empty?)
      0
    else
      selected_stops.first.position-1
    end
  end
  def commercial_stop_areas
    jpsps = JourneyPatternStopPoint.select_journey_pattern( self.journeypatternid)

    # be carefull: a vehicle journey may make a loop
    # so the same commercial stop area may be returned many times in array
    stop_areas = StopArea.find(jpsps.map(&:commercial_stop_area_id))
    stop_area_by_id = {}
    stop_areas.each { |stop_area| stop_area_by_id[stop_area.id] = stop_area}

    jpsps.map { |jpsp| stop_area_by_id[ jpsp.commercial_stop_area_id]}
  end
  
  private
  
  def get_direction
    sql = <<-SQL
      SELECT sa2.name, sa2.id FROM stoppoint AS sp, stoparea AS sa1, stoparea AS sa2
      WHERE sp.position = (SELECT MAX(sp.position) FROM stoppoint AS sp WHERE sp.routeid IN (SELECT routeid FROM vehiclejourney WHERE id = #{self.id}))
      AND sp.routeid IN (SELECT routeid FROM vehiclejourney WHERE id = #{self.id})
      AND sp.stopareaid = sa1.id
      AND sa2.id = sa1.parentid
      LIMIT 1
    SQL
    
    self.class.connection.select_all(sql).first
  end
  
end
