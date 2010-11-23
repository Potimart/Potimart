# id bigint NOT NULL,
# timetableid bigint,
# vehiclejourneyid bigint,


class TimeTableVehicleJourney < ChouetteActiveRecord
  set_table_name :timetablevehiclejourney
  belongs_to :time_table, :class_name => "TimeTable", :foreign_key => "timetableid"
  belongs_to :vehicle_journeys, :class_name => "VehicleJourney", :foreign_key => "vehiclejourneyid"
  
end
