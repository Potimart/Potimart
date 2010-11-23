class CreatePlace < ActiveRecord::Migration
  def self.up
    unless table_exists?("places")
      create_table :places do |t|
        t.string :name, :null => false
        t.text :description
        t.string :address
        t.string :city_code
        t.decimal :lng, :precision => 19, :scale => 16
        t.decimal :lat, :precision => 19, :scale => 16
        t.integer :place_type_id
        t.timestamps
      end 
    end
  end

  def self.down
    drop_table :places
  end
end
