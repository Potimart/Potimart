# id bigint NOT NULL,
# lineid bigint,
# objectid character varying(255),
# objectversion integer,
# creationtime timestamp without time zone,
# creatorid character varying(255),
# name character varying(255),
# publishedname character varying(255),
# number character varying(255),
# direction character varying(255),
# "comment" character varying(255),

class Route < ChouetteActiveRecord
  set_table_name :route
  belongs_to :line, :class_name => "Line", :foreign_key => "lineid"
  has_many :stop_points, :class_name => "StopPoint", :foreign_key => "routeid", :order => 'position', :dependent => :destroy do
    def first
      self.find(:first)
    end
  end
  has_many :stop_areas, :through => :stop_points, :order => 'stoppoint.position' # => impossible ! no position on stop_areas !!!
  has_many :vehicle_journeys, :class_name => "VehicleJourney", :foreign_key => "routeid", :dependent => :destroy, :order => "vehiclejourneyatstop.departuretime", :include => :vehicle_journey_at_stops
  
  named_scope :with_wayback, lambda { |wayback| { :conditions => {:wayback => wayback}}}  
  
  def next_stop_points(stop_point)
    stop_points.find(:all, :conditions => ["position > ?", stop_point.position])
  end
  
  def vehicle_journey_at_stops_from(beginning_stop_area)
    self.stop_points.find_all_by_stopareaid(beginning_stop_area.id).map(&:vehicle_journey_at_stops).flatten
  end
  
  def xml_vehicle_journey_at_stops_from(beginning_stop_area)
    vehicle_journey_at_stops_from(beginning_stop_area).to_xml(:skip_instruct => true, :except => [:modifie])
  end
  
  def vehicle_journey_at_stops_from_grouped_by_hour(beginning_stop_area)
    vehicle_journey_at_stops_from(beginning_stop_area).group_by do |vjas|
      vjas.departuretime.hour
    end
  end
  
  def stop_times_by_hour_from(beginning_stop_area)
    vehicle_journey_at_stops_from_grouped_by_hour(beginning_stop_area).map do |hour, stops|
      [hour, stops.map(&:departuretime).flatten.map(&:min).flatten]
    end.sort_by do |(hour, min)| hour end
  end
  
  def way
    direction == "ALLER" ? "back" : "forth"
  end
end
