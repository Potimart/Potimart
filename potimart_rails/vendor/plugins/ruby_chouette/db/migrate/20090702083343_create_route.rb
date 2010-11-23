class CreateRoute < ActiveRecord::Migration
  def self.up
    unless table_exists?("route")
      create_table :route do |t|
        t.integer  "oppositerouteid", :limit => 8
        t.integer  "lineid", :limit => 8
        t.string   "name"
        t.string   "publishedname"
        t.string   "direction"
        t.timestamps
      end
    end
  end

  def self.down
    drop_table :route
  end
end
