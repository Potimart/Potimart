class CreateStopAreaGeoIndicators < ActiveRecord::Migration
  def self.up
    create_table :stop_area_geo_indicators do |t|
      t.string :name
      t.integer :value
      t.integer :stop_area_geo_id
      t.date :start_date
      t.date :end_date
      
      t.timestamps
    end
  end

  def self.down
    drop_table :stop_area_geo_indicators
  end
end
