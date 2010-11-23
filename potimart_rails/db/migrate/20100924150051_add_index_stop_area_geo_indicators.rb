class AddIndexStopAreaGeoIndicators < ActiveRecord::Migration
  def self.up
    # Create an index on the table:
    add_index :stop_area_geo_indicators, [:name]
  end

  def self.down
    # Remove an index on the table:
    remove_index :stop_area_geo_indicators, [:name]
  end
end
