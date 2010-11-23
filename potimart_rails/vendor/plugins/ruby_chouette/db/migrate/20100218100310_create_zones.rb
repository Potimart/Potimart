class CreateZones < ActiveRecord::Migration
  def self.up
    create_table :geocoder_zones do |t|
      t.string :name
      t.integer :uid

      t.string :stored_words
    end 
  end

  def self.down
    drop_table :geocoder_zones
  end
end
