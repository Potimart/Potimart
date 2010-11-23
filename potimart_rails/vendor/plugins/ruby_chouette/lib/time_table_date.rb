

# No id !!! Rails Issue. Took timetableid as primary id



# timetableid bigint NOT NULL,
# date date,
# "position" integer NOT NULL,
# CONSTRAINT timetable_date_pkey PRIMARY KEY (timetableid, "position"),
# CONSTRAINT fkd767940c5cb6a412 FOREIGN KEY (timetableid)
#     REFERENCES timetable (id) MATCH SIMPLE
#     ON UPDATE NO ACTION ON DELETE NO ACTION


class TimeTableDate < ChouetteActiveRecord
  set_primary_key :timetableid
  set_table_name :timetable_date
  belongs_to :time_table, :class_name => "TimeTable", :foreign_key => "timetableid"
  # acts_as_list
  
end
