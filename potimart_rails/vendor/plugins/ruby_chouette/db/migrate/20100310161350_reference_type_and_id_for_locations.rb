class ReferenceTypeAndIdForLocations < ActiveRecord::Migration
  def self.up
    change_table :geocoder_locations do |t|
      t.integer :reference_id
      t.string :reference_type
    end

    type_from_uid = "rtrim(reference_uid,'0123456789:')"
    execute "update geocoder_locations set reference_type = #{type_from_uid}, reference_id = cast(substr(reference_uid, length(#{type_from_uid}) + 2) as integer);"

    remove_column :geocoder_locations, :reference_uid
  end
  
  def self.down
    add_column :geocoder_locations, :reference_uid

    execute "update geocoder_locations set reference_uid = reference_type || ':' || reference_id"

    change_table :geocoder_locations do |t|
      t.remove :reference_id
      t.remove :reference_type
    end
  end
end
