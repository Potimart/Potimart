class AddZipCodeToZone < ActiveRecord::Migration

  def self.up
    add_column :geocoder_zones, :zip_code, :string
    # Use City#zip_code and Zone#zip_code
    execute "update geocoder_zones set zip_code = lpad(city.zip_code || '',5,'0') from cities as city where geocoder_zones.uid = cast(city.insee_code as integer)"
  end

  def self.down
    remove_column :geocoder_zones, :zip_code
  end

end
