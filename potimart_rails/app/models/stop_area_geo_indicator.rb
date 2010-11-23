class StopAreaGeoIndicator < ActiveRecord::Base
  belongs_to :stop_area_geo
  named_scope :between_date, lambda{|*args| {:conditions => ['? BETWEEN start_date AND end_date', (args.first || Date.today)]}}
  named_scope :by_name, lambda{|*args| {:conditions => ['name = ?', (args.first)]}}

  validates_presence_of :name
  validates_uniqueness_of :name, :scope => [:stop_area_geo_id]

  validates_presence_of :value

  def self.create_population_indicator()
    StopAreaGeoIndicator.transaction do
      StopAreaGeo.find(:all).each do |stop_area_geo|
        if stop_area_geo.the_geom
          iris = stop_area_geo.iris_intersection()
          StopAreaGeoIndicator.create!:stop_area_geo_id => stop_area_geo.id,
            :name => "population",
            :value => iris ? iris.psdc : 0
        end
      end
    end
  end

  def self.create_test_indicator(name)
    StopAreaGeoIndicator.transaction do
      StopAreaGeo.find(:all).each do |stop_area_geo|
        StopAreaGeoIndicator.create!:stop_area_geo_id => stop_area_geo.id,
          :name => name,
          :value => rand(6000)
      end
    end
  end

  def self.names()
    StopAreaGeoIndicator.find_by_sql "SELECT DISTINCT stop_area_geo_indicators.name FROM stop_area_geo_indicators "
  end
  
end
