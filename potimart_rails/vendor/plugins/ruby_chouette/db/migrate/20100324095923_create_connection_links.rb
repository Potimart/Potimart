class CreateConnectionLinks < ActiveRecord::Migration
  def self.up
    unless table_exists?("connectionlink")
      create_table "connectionlink" do |t|
        t.integer  "departureid",           :limit => 8
        t.integer  "arrivalid",           :limit => 8
        t.string   "objectid"
        t.integer  "objectversion"
        t.datetime "creationtime"
        t.string   "creatorid"
        t.string   "name"
        t.string   "comment"
        t.decimal   "linkdistance",  :precision => 19, :scale => 2
        t.string   "linktype"
        t.datetime  "defaultduration"
        t.datetime  "frequenttravellerduration"
        t.datetime  "occasionaltravellerduration"
        t.datetime   "mobilityrestrictedtravellerduration"
        t.boolean  "mobilityrestrictedsuitability"
        t.boolean  "stairsavailability"
        t.boolean   "liftavailability"
      end

      add_index "connectionlink", ["objectid"], :name => "connectionlink_objectid_key", :unique => true
    end
  end

  def self.down
    drop_table :connectionlink
  end
end
