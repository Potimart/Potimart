class Place < ChouetteActiveRecord
  belongs_to :place_type
  validates_presence_of :name
  has_many :stop_area_places
  has_many :stop_areas, :through => :stop_area_places

  acts_as_mappable :lng_column_name => "lng",  :lat_column_name => "lat", :default_units => :kms, :default_formula => :flat
  
  validates_presence_of :lat, :message => "Both Latitude and Longitude have to be null or valid", :if => Proc.new { |place| !place.lng.blank? }
  validates_presence_of :lng, :message => "Both Latitude and Longitude have to be null or valid", :if => Proc.new { |place| !place.lat.blank? }
  
  
  # Bounds of France
  validates_numericality_of :lat, :allow_nil => true,
                            :greater_than => 43.69965122967144,
                            :lesser_than  => 47.53945554474239
  validates_numericality_of :lng, :allow_nil => true, 
                            :greater_than => 0.076904296875,
                            :lesser_than  => 10.98632812500
  
  named_scope :all_by_selected_types, lambda { |place_type_array| {:conditions => {:place_type_id => place_type_array} } }
  named_scope :all_from_cities, lambda { |*args| {:conditions => {:city_code => args.first} } }
 
  extend AreaSearch

  # ====================
  # = Rake functions =
  # ====================

  def self.load_stop_area_association(radius)
    Place.all.each do |place|
      total = StopArea.stop_areas_in_neighborhood( place, radius).map do |stop_area|
        StopAreaPlace.new(:stop_area_id => stop_area.id,
            :place_id => place.id,
            :duration => stop_area.access_time).save
      end.size

      if total == 0
        larger_radius = 6 * radius
        StopArea.stop_areas_in_neighborhood( place, larger_radius).each do |stop_area|
          StopAreaPlace.new(:stop_area_id => stop_area.id,
              :place_id => place.id,
              :duration => stop_area.access_time).save
        end
      end
    end
  end

  def self.load_city_places(zip_codes)
    # create Commune place_type if necessary
    place_type = PlaceType.find_by_name("Commune")
    if place_type.nil?
      place_type = PlaceType.new(:name => "Commune")
      place_type.save!
    end

    # clean existing place for Commune
    place_type.places.each { |p| p.destroy}

    expression = Regexp.new( "^(#{zip_codes.join("|")})\\d{3}$")
    city_index = 0

    cfg = Application.config.itineraries
    center = Geokit::LatLng.new( cfg.center.lat, cfg.center.lng)
    max_distance = cfg.address.radius_from_center

    self.transaction do
      # loop on cities matching given zip_codes
      City.all.
        select { |c| c.zip_code.to_s.match(expression) }.
        reject { |c| c.zip_code.to_s.match(/75\d{3}/) &&
                     c.insee_code.to_s!="75056"}.each do |c|

        location = Geokit::LatLng.new( c.lat, c.lng)

        # check location validity
        if c.lat && c.lng && location.distance_to(center)<max_distance
          place = Place.new( :name => c.name, :city_code => c.insee_code,
                             :place_type_id => place_type.id, :lat => c.lat,
                             :lng => c.lng)
          place.save!

          # if city stands for Paris
          if c.insee_code.to_s == "75056"
            self.paris_main_stop_areas.each do |s|
              StopAreaPlace.new(:place_id => place.id,
                      :stop_area_id => s.id, :duration => 0).save!
            end
          else
            # link to 'station' located in the city
            total_stations = StopArea.commercial.
              mode_compliant("Train", "RapidTransit").
              select {|s| s.countrycode==c.insee_code.to_s}.first(10).uniq.map do |s|
              StopAreaPlace.new(:place_id => place.id,
                      :stop_area_id => s.id, :duration => 0).save!
            end.size

            # if no station in the city,
            # link to 'bus stops' in the city
            # otherwise to the closest stop
            if total_stations.zero?
              total_city_stops = StopArea.commercial.
                find_all_by_countrycode(c.insee_code.to_s).first(10).map do |s|
                StopAreaPlace.new(:place_id => place.id,
                        :stop_area_id => s.id, :duration => 0).save!
              end.size

              if total_city_stops.zero?
                closest = StopArea.find_closest(:origin => place)

                StopAreaPlace.new(:place_id => place.id,
                        :stop_area_id => closest.id,
                        :duration => closest.access_time_to( place, 1.2, 4)).save!
              end

            end
          end
        end
        city_index += 1
        if (city_index % 20 == 0)
          print '.'
          STDOUT.flush
        end
      end
    end
  end

  def self.paris_main_stop_areas
    StopArea.commercial.mode_compliant("Train").
      select { |s| s.countrycode.to_s.match(/75\d{3}/)} +
    StopArea.commercial.mode_compliant("RapidTransit").
      select { |s| s.countrycode.to_s.match(/75\d{3}/) && s.name.match(/HALLES/)}
  end

  def self.remove_disconned_places
    Place.all.select {|p| p.stop_areas.empty?}.each { |p| p.destroy}
  end

  # ====================
  # = Search interface =
  # ====================
  
  def self.search(search_string)
    logger.info search_string.inspect
    find(:all, :order => "name ASC", :conditions => ['name ilike ?', "%#{search_string}%"])
  end

  def self.itinerary_stops_search(search_string, options = {})
    if conditions = options[:conditions]
      options[:conditions] = conditions.rename_keys(:longitude => :lng, :latitude => :lat)
    end

    places_found = self.find_by_city(search_string,options) + self.find_by_name(search_string,options)
    
    # filter places which are connected to a stop_area
    connected_places = StopAreaPlace.find(:all).map(&:place_id)
    places_found.select { |place| connected_places.include?(place.id) }
  end

  # ====================
  # = City association =
  # ====================
  
  def city
    City.find_by_insee_code(city_code.to_i)
  end
  
  def self.all_cities
    City.find_all_by_insee_code(all.map(&:city_code).uniq.compact.map(&:to_i))
  end
  
  # Deletes stop_area_places for stop_areas that no longuer exist !
  def check_stop_areas
    sql = <<-SQL
    SELECT sap.* FROM stop_area_places AS sap, places AS p
    	WHERE sap.place_id = p.id
    	AND p.id = #{self.id}
    	AND sap.stop_area_id NOT IN (SELECT s.id FROM stoparea AS s)
    SQL
    self.stop_area_places.find_by_sql(sql).each( &:destroy)
  end
  
  def description
    ""
  end

  private  
    def self.adpat_options( options)
      conditions = options[:conditions]
      return {} unless conditions
      
      lat_rg = conditions[:lat] if conditions.has_key?(:lat)
      lat_rg = conditions[:latitude] if conditions.has_key?(:latitude)
      lng_rg = conditions[:lng] if conditions.has_key?(:lng)
      lng_rg = conditions[:longitude] if conditions.has_key?(:longitude)
      
      return {} if (lat_rg.nil? || lng_rg.nil?)
      
      { :conditions => { :lat => lat_rg, :lng => lng_rg}}
    end
end
