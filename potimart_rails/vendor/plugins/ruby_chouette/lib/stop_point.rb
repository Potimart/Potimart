# id bigint NOT NULL,
# routeid bigint,
# stopareaid bigint,
# modifie boolean,
# "position" integer,
# objectid character varying(255),
# objectversion integer,
# creationtime timestamp without time zone,
# creatorid character varying(255),

class StopPoint < ChouetteActiveRecord
  set_table_name :stoppoint
  belongs_to :stop_area, :class_name => "StopArea", :foreign_key => "stopareaid"
  belongs_to :creator, :class_name => "User", :foreign_key => "creatorid"
  belongs_to :route, :class_name => "Route", :foreign_key => "routeid"
  has_many :vehicle_journey_at_stops, :class_name => "VehicleJourneyAtStop", :foreign_key => "stoppointid", :order => 'departuretime', :dependent => :destroy
  has_many :vehicle_journeys, :through => :vehicle_journey_at_stops, :uniq => true


  def commercial_stop_area
    stop_area.get_commercial_stop_area || stop_area rescue stop_area
  end
  
  def lat
    _lat = stop_area.lat
    _lat ||= commercial_stop_area.lat
  end
  
  def lng
    _lng = stop_area.lng
    _lng ||= commercial_stop_area.lng
  end
  
  
  def next_vehicle_journeys(amount=5, time=Time.now)
    vjas = vehicle_journey_at_stops.find(:all, :conditions => ["departuretime > ?", Time.utc(2000,"jan",1, time.hour, time.min) ], :limit => amount)
    vjas.map(&:vehicle_journey)
  end
end
