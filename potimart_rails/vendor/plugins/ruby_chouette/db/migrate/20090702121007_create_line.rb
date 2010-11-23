class CreateLine < ActiveRecord::Migration
  def self.up
    unless table_exists?("line")
      create_table :line do |t|
        t.string   "name"
        t.string   "publishedname"
        t.string   "number"
        t.string   "registrationnumber"
        t.string   "transportmodename"
        t.timestamps
      end
    end
  end

  def self.down
    drop_table :line
  end
end
