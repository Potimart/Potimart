class CreateStopAreaGeos < ActiveRecord::Migration
  def self.up
    create_table :stop_area_geos do |t|
      t.string :name
      t.string :area_type
      t.point :the_geom, :srid => 4326
      t.belongs_to :stoparea

      t.timestamps
    end
  end

  def self.down
    drop_table :stop_area_geos
  end
end
