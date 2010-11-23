class CreatePathlinks < ActiveRecord::Migration
  def self.up
    create_table :pathlinks do |t|
      t.integer :line_id
      t.integer :route_id
      t.integer :journeypattern_id
      t.integer :stoparea_start_id
      t.integer :stoparea_arrival_id
      t.datetime :departure_time
      t.datetime :arrival_time
      t.integer :duration
      t.line_string :the_geom, :srid => 4326
      
      t.timestamps
    end
  end

  def self.down
    drop_table :pathlinks
  end
end
