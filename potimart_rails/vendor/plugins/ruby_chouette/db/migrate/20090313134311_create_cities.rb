class CreateCities < ActiveRecord::Migration
  def self.up
    unless table_exists?("cities")
      create_table :cities do |t|
        t.string :name, :upcase_name
        t.integer :zip_code, :insee_code, :region_code
        t.decimal :lat, :lng, :precision => 19, :scale => 16
        t.float :eloignement
      end 
      add_index :cities, :name
    end
  end

  def self.down
    drop_table :cities
  end
end
