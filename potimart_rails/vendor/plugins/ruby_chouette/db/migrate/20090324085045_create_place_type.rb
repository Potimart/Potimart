class CreatePlaceType < ActiveRecord::Migration
  def self.up
    unless table_exists?("place_types")
      create_table :place_types do |t|
        t.string :name
        t.timestamps
      end 
    end
  end

  def self.down
    drop_table :place_types
  end
end
