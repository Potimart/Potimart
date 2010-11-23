class CreateVehicleJourneyAtStop < ActiveRecord::Migration
  def self.up
    unless table_exists?("vehiclejourneyatstop")
      create_table :vehiclejourneyatstop do |t|
        t.integer  "vehiclejourneyid"
        t.integer  "stoppointid"
        t.datetime "arrivaltime"
        t.datetime "departuretime"

        t.timestamps
      end
    end
  end

  def self.down
    drop_table :vehiclejourneyatstop
  end
end
