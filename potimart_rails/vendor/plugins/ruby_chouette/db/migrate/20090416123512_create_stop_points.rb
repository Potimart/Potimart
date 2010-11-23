class CreateStopPoints < ActiveRecord::Migration
  def self.up
    unless table_exists?("stoppoint")
      create_table "stoppoint" do |t|
        t.integer  "routeid",  :limit => 8
        t.integer  "stopareaid",    :limit => 8
        t.boolean  "modifie"
        t.integer  "position"
        t.string   "objectid"
        t.integer  "objectversion"
        t.datetime "creationtime"
        t.string   "creatorid"
      end

      add_index "stoppoint", ["objectid"], :name => "stoppoint_objectid_key", :unique => true
    end
  end

  def self.down
    drop_table :stoppoint
  end
end
