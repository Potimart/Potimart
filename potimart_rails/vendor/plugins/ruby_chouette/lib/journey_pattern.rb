class JourneyPattern < ChouetteActiveRecord
  set_table_name :journeypattern
  has_many :vehicle_journeys, :foreign_key => "journeypatternid", :include => :vehicle_journey_at_stops
  has_many :vehicle_journey_at_stops, :through => :vehicle_journeys, :uniq => true do # should necesarely be true anyways
    def for_stop_point(sp)
      find(:all, :conditions => ["stoppointid = ?", sp.id])
    end
  end
  
  def sp
    stop_points
  end
  
  def vjs
    vehicle_journeys
  end
  
  def vjass
    vehicle_journey_at_stops
  end
end