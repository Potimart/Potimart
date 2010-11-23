class RenameAddressInRoad < ActiveRecord::Migration
  def self.up
    rename_table :addresses, :roads if table_exists?(:addresses)
    if table_exists?(:address_sections)
      rename_table :address_sections, :road_sections 
      rename_column :road_sections, :address_id, :road_id
    end
    execute("update geocoder_locations set reference_type = 'Chouette::Geocoder::Road' where reference_type = 'Chouette::Geocoder::Address'")
  end

  def self.down
    rename_table :roads, :addresses if table_exists?(:roads)
    if table_exists?(:road_sections)
      rename_table :road_sections, :address_sections 
      rename_column :road_sections, :road_id, :address_id
    end
    execute("update geocoder_locations set reference_type = 'Chouette::Geocoder::Address' where reference_type = 'Chouette::Geocoder::Road'")
  end
end
