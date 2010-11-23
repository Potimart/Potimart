class CreateJourneyPattern < ActiveRecord::Migration
  def self.up
    unless table_exists?("journeypattern")
      create_table :journeypattern do |t|
        t.string   "name"
        t.string   "publishedname"
        t.string   "registrationnumber"
        t.timestamps
      end
    end
  end

  def self.down
    drop_table :journeypattern
  end
end
