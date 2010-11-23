class AddIndexForTimetableAtStop < ActiveRecord::Migration
  def self.up
    add_index :stoparea, :parentid
    add_index :stoppoint, :stopareaid
    add_index :timetablevehiclejourney, :timetableid
    add_index :timetablevehiclejourney, :vehiclejourneyid
    add_index :timetable_date, :timetableid
    add_index :timetable_period, :timetableid
    add_index :vehiclejourney, :routeid
    add_index :route, :lineid
    add_index :vehiclejourneyatstop, :stoppointid
    add_index :vehiclejourneyatstop, :vehiclejourneyid
    add_index :journey_pattern_stop_points, :journey_pattern_id
    add_index :journey_pattern_stop_points, :stop_point_id
    add_index :journey_pattern_stop_points, :commercial_stop_area_id
  end

  def self.down
    remove_index :stoparea, :parentid
    remove_index :stoppoint, :stopareaid
    remove_index :timetablevehiclejourney, :timetableid
    remove_index :timetablevehiclejourney, :vehiclejourneyid
    remove_index :timetable_date, :timetableid
    remove_index :timetable_period, :timetableid
    remove_index :vehiclejourney, :routeid
    remove_index :route, :lineid
    remove_index :vehiclejourneyatstop, :stoppointid
    remove_index :vehiclejourneyatstop, :vehiclejourneyid
    remove_index :journey_pattern_stop_points, :journey_pattern_id
    remove_index :journey_pattern_stop_points, :stop_point_id
    remove_index :journey_pattern_stop_points, :commercial_stop_area_id
  end
end
