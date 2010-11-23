class CreateVehicleJourney < ActiveRecord::Migration
  def self.up
    unless table_exists?("vehiclejourney")
      create_table :vehiclejourney do |t|
        t.integer  "routeid"
        t.integer  "journeypatternid"
        t.string   "transportmode"
        t.timestamps
      end
    end
  end

  def self.down
    drop_table :vehiclejourney
  end
end
