class CreateStopAreaPlace < ActiveRecord::Migration
  def self.up
    unless table_exists?("stop_area_places")
      create_table :stop_area_places do |t|
        t.integer :stop_area_id, :place_id, :duration
        t.timestamps
      end 
    end
  end

  def self.down
    drop_table :stop_area_places
  end
end
