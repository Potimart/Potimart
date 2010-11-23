# id bigint NOT NULL,
# objectid character varying(255),
# objectversion integer,
# creationtime timestamp without time zone,
# creatorid character varying(255),
# version character varying(255),
# "comment" character varying(255),


class TimeTable < ChouetteActiveRecord
  set_table_name :timetable

                
  belongs_to :creator, :class_name => "User", :foreign_key => "creatorid"
  has_many   :time_table_vehicle_journeys, :class_name => "TimeTableVehicleJourney", :foreign_key => "timetableid"
  has_many   :vehicle_journeys, :class_name => "VehicleJourney", :through => :time_table_vehicle_journeys
  has_many :dates, :class_name => "TimeTableDate", :foreign_key => "timetableid", :order => 'date', :dependent => :destroy
  has_many :periods, :class_name => "TimeTablePeriod", :foreign_key => "timetableid", :dependent => :destroy

end
