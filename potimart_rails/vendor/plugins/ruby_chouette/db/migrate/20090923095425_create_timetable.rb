class CreateTimetable < ActiveRecord::Migration
  def self.up
    unless table_exists?("timetable")
      create_table :timetable do |t|
        t.string   "objectid"
        t.integer  "objectversion"
        t.datetime "creationtime"
        t.string   "creatorid"
        t.string   "version"
        t.string   "comment"
        t.integer  "intdaytypes",   :default => 0
      end

      add_index "timetable", ["objectid"], :name => "timetable_objectid_key", :unique => true
    end


    unless table_exists?("timetable_date")
      create_table :timetable_date do |t|
        t.integer "timetableid", :null => false
        t.date    "date"
        t.integer "position",    :null => false
      end
    end

    unless table_exists?("timetable_period")
      create_table :timetable_period do |t|
        t.integer "timetableid", :null => false
        t.date    "periodstart"
        t.date    "periodend"
        t.integer "position",    :null => false
      end
    end

    unless table_exists?("timetablevehiclejourney")
      create_table :timetablevehiclejourney do |t|
        t.integer "timetableid"
        t.integer "vehiclejourneyid"
      end
    end

  end

  def self.down
    remove_index "timetable", "timetable_objectid_key"
    drop_table :timetable

    drop_table :timetable_date
    drop_table :timetable_period
    drop_table :timetablevehiclejourney

  end
end
