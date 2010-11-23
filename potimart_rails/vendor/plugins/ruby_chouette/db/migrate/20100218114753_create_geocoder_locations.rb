class CreateGeocoderLocations < ActiveRecord::Migration
  def self.up
    create_table :geocoder_locations do |t|
      t.string :name
      t.string :reference_uid
      t.belongs_to :zone

      t.string :stored_words
      t.string :stored_phonetics
    end 
  end

  def self.down
    drop_table :geocoder_locations
  end
end
