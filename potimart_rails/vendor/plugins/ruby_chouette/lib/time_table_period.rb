

# No id !!! Rails Issue. Took timetableid as primary id



# timetableid bigint NOT NULL,
# periodstart date,
# periodend date,
# "position" integer NOT NULL,
# CONSTRAINT timetable_period_pkey PRIMARY KEY (timetableid, "position"),
# CONSTRAINT fkb0847a9f5cb6a412 FOREIGN KEY (timetableid)
#     REFERENCES timetable (id) MATCH SIMPLE
#     ON UPDATE NO ACTION ON DELETE NO ACTION

require 'acts_as_list'

class TimeTablePeriod < ChouetteActiveRecord
  set_primary_key :timetableid
  set_table_name :timetable_period
  belongs_to :time_table, :class_name => "TimeTable", :foreign_key => "timetableid"
  acts_as_list

end
