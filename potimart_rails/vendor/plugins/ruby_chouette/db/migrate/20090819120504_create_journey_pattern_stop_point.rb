class CreateJourneyPatternStopPoint < ActiveRecord::Migration
  def self.up
    unless table_exists?("journey_pattern_stop_points")
      create_table :journey_pattern_stop_points do |t|
        t.integer :journey_pattern_id
        t.integer :route_id
        t.integer :line_id
        t.integer :stop_point_id
        t.integer :stop_area_id
        t.integer :commercial_stop_area_id
        t.integer :position
        t.boolean :terminus
        t.boolean :is_outward
        t.timestamps
      end
    end
  end

  def self.down
    drop_table :journey_pattern_stop_points
  end
end
