class City < ChouetteActiveRecord

  def self.load_more(path)
    cities = IO.readlines( path)[1..-1]
    puts "#{cities.length} cities to import. It might take a while..."

    City.transaction do

      puts "import cities :"
      cities.each_with_index do |city, city_index|
        name, upname, zip_code, insee_code, region_code, lat, lng, eloignement = city.split(';').map { |property| property.gsub('"', '').strip }
        City.find_or_create_by_insee_code :name        => name,
                                         :upcase_name => upname,
                                         :zip_code    => zip_code.to_i,
                                         :insee_code  => insee_code.to_i,
                                         :region_code => region_code.to_i,
                                         :lat         => lat.to_f,
                                         :lng         => lng.to_f,
                                         :eloignement => eloignement.to_f

        if (city_index % 100 == 0)
          print '.'
          STDOUT.flush
        end
      end
    end
    puts "\n#{City.count} in table"
  end
  
  def self.load(path)
    cities = IO.readlines( path)[1..-1]
    puts "#{cities.length} cities to import. It might take a while..."

    City.transaction do 
      puts "destroy all current cities"
      City.destroy_all

      puts "import cities :"
      cities.each_with_index do |city, city_index|
        name, upname, zip_code, insee_code, region_code, lat, lng, eloignement = city.split(';').map { |property| property.gsub('"', '').strip }
        City.create! :name        => name,
                     :upcase_name => upname,
                     :zip_code    => zip_code.to_i,
                     :insee_code  => insee_code.to_i,
                     :region_code => region_code.to_i,
                     :lat         => lat.to_f,
                     :lng         => lng.to_f,
                     :eloignement => eloignement.to_f

        if (city_index % 100 == 0)
          print '.' 
          STDOUT.flush
        end
      end
    end
    puts "\n#{City.count} imported"
  end

  def self.update_locatisation(zip_codes)
    city_index = 0
    expression = Regexp.new( "^(#{zip_codes.join("|")})\\d{3}$")
    City.all.select { |c| c.zip_code.to_s.match(expression) }.each do |c|
      loc = Geokit::Geocoders::GoogleGeocoder.geocode( "#{c.name}, #{c.zip_code}, FR")
      if loc.zip==c.zip_code.to_s
        c.update_attributes( :lat => loc.lat, :lng => loc.lng)
      end
      city_index += 1
      if (city_index % 20 == 0)
        print '.'
        STDOUT.flush
      end
    end
  end
  
  def self.find_by_name(search_string, city_ids)
    search_string = search_string.tr('();[]',' ')
    [search_string.strip.split(' '), search_string].flatten.map do |string_part|
      City.all(:conditions => [ "name ~* ? AND id in (?)", string_part, city_ids] )
    end.flatten.uniq
  end
  
  def stop_areas
    StopArea.all(:conditions => { :countrycode => self.insee_code.to_s })
  end
  
  def commercial_stop_areas
    StopArea.find_commercial(:all, :conditions => { :countrycode => self.insee_code.to_s })
  end
  
  def places
    Place.all(:conditions => { :city_code => self.insee_code.to_s })
  end

end
