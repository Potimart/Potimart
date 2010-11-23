# coding: utf-8
# id bigint NOT NULL,
# objectid character varying(255),
# objectversion integer,
# creationtime timestamp without time zone,
# creatorid character varying(255),
# name character varying(255),
# "comment" character varying(255),
# areatype character varying(255),
# nearesttopicname character varying(255),
# boardingfarecode integer,
# alightingfarecode integer,
# longitude numeric(19,2),
# latitude numeric(19,2),
# longlattype character varying(255),
# x numeric(19,2),
# y numeric(19,2),
# projectiontype character varying(255),
# countrycode character varying(255),
# streetname character varying(255),

require "acts_as_tree"

class StopArea < ChouetteActiveRecord
  extend AreaSearch
  
  # include StopAreaSearch
  set_table_name :stoparea
  acts_as_mappable :lng_column_name => "longitude",  :lat_column_name => "latitude", :default_units => :kms, :default_formula => :flat
  attr_accessor :access_time # duration starting from an address (in seconds)
  before_create :set_defaults
  has_many :stop_points, :class_name => "StopPoint", :foreign_key => "stopareaid", :order => 'position', :dependent => :destroy

  has_many :stop_area_places
  has_many :places, :through => :stop_area_places
  belongs_to :creator, :class_name => "User", :foreign_key => "creatorid"
  acts_as_tree :foreign_key => 'parentid'
  
  named_scope :commercial, :conditions => { :areatype => "CommercialStopPoint" }
  named_scope :without_parent, :conditions => { :parentid => nil }
  named_scope :all_from_cities, lambda { |*args| {:conditions => {:countrycode => args.first} } }
  named_scope :stop_place, :conditions => { :areatype => "StopPlace" }

  def siblings
    return [self] if self.parentid.nil?
    StopArea.find_all_by_parentid(self.parentid)
  end

  def self.cache_find_results
    class << self
      extend ActiveSupport::Memoizable
      memoize :find
      nil
    end
  end

  def self.denormalize_transport_mode
    self.transaction do
      self.connection().update("UPDATE stoparea set modes=0")

      Chouette::TRANSPORT_MODES.each do |key, value|
        sql = <<-SQL
          UPDATE
            stoparea
          SET modes = modes + #{2 ** value}
          WHERE
            id in (
              SELECT
                ac.id
              FROM
                stoparea ac,
                stoparea sp,
                stoppoint p,
                route r,
                line l
              WHERE ac.areatype='CommercialStopPoint'
              AND sp.parentid=ac.id
              AND p.stopareaid=sp.id
              AND p.routeid=r.id
              AND r.lineid=l.id
              AND l.transportmodename in ('#{key}'));
            SQL
        self.connection().update(sql) if value >= 0
      end
    end
  end

  named_scope :mode_compliant, lambda { |*args|
                {:conditions => self.mode_clause(args) } }

  private

  def self.mode_clause(modes, &block)
    returning [ ""] do |clause|
      modes.each do |mode|
        mode_key = Chouette::TRANSPORT_MODES[mode]
        raise "#{mode} is an unknown mode, known modes are #{Chouette::TRANSPORT_MODES.keys.join(',')}" unless mode_key
        yield mode_key if block_given?
        clause.first.concat( " OR") unless clause.first.blank?
        clause.first.concat( " modes & ? = ?")
        clause.push(2 ** mode_key, 2 ** mode_key)
      end
    end
  end

  public

  # location to reach
  # ratio : used to increase distance
  # walk_speed: km walked in one hour
  def access_time_to( location, ratio, walk_speed)
    access_time = ( (ratio * location.distance_to(self)) / walk_speed) * 3600

    # round to the nearest minute
    (access_time / 60.0).round * 60.0
  end

  def self.stop_areas_in_neighborhood(location, radius, max=10)

    neighbours_stop_areas = StopArea.commercial.find_within( radius, 
                    :origin => location, :order => "distance")

    neighbours_stop_areas.each do |sa|
      # 20% increase because of walk
      # speed 4 km / h 
      sa.access_time = sa.access_time_to(location, 1.2, 4)
    end
    neighbours_stop_areas.first max
  end

  def self.noparent_in_neighborhood(location, radius, max=10)

    neighbours_stop_areas = StopArea.without_parent.find_within( radius,
                    :origin => location, :order => "distance")

    neighbours_stop_areas.each do |sa|
      # 30% increase because of walk
      # speed 4 km / h
      sa.access_time = sa.access_time_to(location, 1.3, 4)
    end
    neighbours_stop_areas.first max
  end

  def self.find_nearest_stop_place(location, radius)
    # TODO use/create something like Geokit::LatLng#valid?/complete?
    return unless location.is_a?(Geokit::LatLng) and location.lat and location.lng

    StopArea.stop_place.find_nearest(:origin => location,
                                     :within => radius)
  end

  def self.geo_partition( locations, distance)
    returning([]) do |partition|
      locations.each do |location|
        found = false
        partition.map(&:first).each_with_index do |first,index|
          found = first.distance_to(location) < distance
          if found
            partition[index] << location
            break
          end
        end

        partition << [location] unless found
      end
    end
  end

  def self.compute_stop_place(distance)
    stops_by_name = StopArea.commercial.reject { |s| s.lat.nil? || s.lng.nil?}.
                      group_by(&lambda {|c| c.name.upcase})

    stops_by_name.values.reject { |homonymes| homonymes.size==1}.each do |homonymes|
      partition = self.geo_partition(homonymes,distance)

      partition.reject { |stops| stops.size==1}.each do |area_homonymes|
        first = area_homonymes.first
        p = StopArea.new(:areatype => "StopPlace",
                         :name => first.name,
                         :objectid => first.objectid+"_StopPlace",
                         :countrycode => first.countrycode,
                         :longlattype => first.longlattype,
                         :latitude => (area_homonymes.map(&:latitude).sum/area_homonymes.size),
                         :longitude => (area_homonymes.map(&:longitude).sum/area_homonymes.size))
        p.save!
        area_homonymes.each { |homonyme| homonyme.update_attributes( :parentid => p.id)}
      end
    end
  end

  def children_in_depth
    return [] if self.children.empty?

    self.children + self.children.map do |child|
      child.children_in_depth
    end.flatten.compact
  end

  # ====================
  # = Search interface =
  # ====================
  
  def self.itinerary_stops_search(search_string, options={})
    self.find_by_city(search_string, options) + self.find_by_name(search_string, options)
  end
  
  # ====================
  # = City association =
  # ====================
  
  def city
    City.find_by_insee_code(countrycode.to_i)
  end
  
  def self.all_cities
    City.find_all_by_insee_code(all.map(&:countrycode).uniq.compact.map(&:to_i))
  end
  
  def commercial_children
    filter_commercial = lambda { |c| c.areatype ==  "CommercialStopPoint" }
    stop_children = children.select(&filter_commercial)
    stop_grand_children = stop_children.map(&:children).flatten.select(&filter_commercial)
    stop_children + stop_grand_children
  end

  def commercial_child_ids
    commercial_children.collect(&:id)
  end
  
  def all_stop_points
    sps = stop_area.stop_points
    sps =+ stop_area.children.map { |sa| sa.stop_points }.flatten
    sps
  end
  
  # This is what is going to be displayed to diffenrenciate records
  # ex : we have a collection of stop_areas that all have "Mairie"
  # for name. The complementary_name should be able to diffrentiate
  # them. Could be for example the city name
  def self.find_commercial(*args)
    with_scope(:find => { :conditions => { :areatype => "CommercialStopPoint" } }) do
      self.find(*args)
    end
  end
  
  def get_commercial_stop_area
    stop_area = self
    while stop_area.areatype != "CommercialStopPoint"
      stop_area = stop_area.parent
      raise "No parent CommercialStopPoint found" unless stop_area
    end
    stop_area
  end

  def parent_stop_place
    stop_area = self
    while not stop_area.nil? and stop_area.areatype != "StopPlace"
      stop_area = stop_area.parent
    end
    stop_area
  end
  
  def zip_code
    self.countrycode
  end
  
  def address
    self.streetname
  end
  
  def lat
    real_latitude
  end
  
  def lng
    real_longitude
  end

  def all_stop_points
    (children.map { |child| child.stop_points } + stop_points).flatten.uniq
  end
  
  def real_latitude
    return self.latitude.to_f if self.latitude
    return self.children.first.latitude.to_f if !self.children.blank? && self.children.first.latitude
    nil
  end
  
  def real_longitude
    return self.longitude.to_f if self.longitude
    return self.children.first.longitude.to_f if !self.children.blank? && self.children.first.longitude
    nil
  end
  
  
  def routes
    sps = if children
      all_stop_points.uniq
    else
      stop_points
    end
    sps.map(&:route)
  end
  
  def to_json
    { :name => name, :lat => lat, :lng => lng, :id => id, :type => 'station' }.to_json
  end
  
  def description
    ""
  end
  
  def stop_type
    "stop_area"
  end
  
  
  private
    def set_defaults
      self.creationtime = Time.now unless @creationtime
      self.objectversion = 1 unless @objectversion
      return true
    end
end
