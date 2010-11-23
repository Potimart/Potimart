unless defined? Rails
  require "rubygems"

  require "active_record"
  require "action_controller"

  require "geokit"
  require "geokit-rails"

  require "acts_as_list"
  require "acts_as_tree"
  
  require "search_api"

  unless defined? RAILS_ENV
    RAILS_ENV = (ENV["RAILS_ENV"] or "development") 
  end

end
  
lib_path = File.dirname(__FILE__)
$:.unshift lib_path unless $:.include?(lib_path)

module Chouette

  def self.env
    return Rails.env if defined?(Rails)
    return RAILS_ENV if defined?(RAILS_ENV)
    return ENV['RAILS_ENV'] if ENV['RAILS_ENV']
    return ENV['CHOUETTE_ENV'] if ENV['CHOUETTE_ENV']

    "development"
  end

  def self.enabled?
    @enabled ||= ChouetteActiveRecord.connected?
  end

end

require "chouette/core_ext"
require "chouette/batches"
require "chouette_active_record"
require "french_text"
require "time_table_vehicle_journey"
require "area_search"
require "stop_area_place"
require "place_type"

require "city"
require "company"
require "journey_pattern"
require "journey_pattern_stop_point"
require "line"
require "place"
require "pt_network"
require "route"
require "ruby_chouette"
require "stop_area"
require "stop_point"
require "time_table_date"
require "time_table_period"
require "time_table"
require "vehicle_journey_at_stop"
require "vehicle_journey"
require 'geocode'

require 'chouette/geocoder'

module Chouette

  def self.enabled?
    @enabled ||= (ChouetteActiveRecord.connection rescue nil) ? true : false
  end
  
  TRANSPORT_MODES = {
    "Interchange"       => -1,
    "Unknown"           => 0,
    "Coach"             => 1,
    "Air"               => 2,
    "Waterborne"        => 3,
    "Bus"               => 4,
    "Ferry"             => 5,
    "Walk"              => 6,
    "Metro"             => 7,
    "Shuttle"           => 8,
    "RapidTransit"      => 9,
    "Taxi"              => 10,
    "LocalTrain"        => 11,
    "Train"             => 12,
    "LongDistanceTrain" => 13,
    "Tramway"           => 14,
    "Trolleybus"        => 15,
    "PrivateVehicle"    => 16,
    "Bicycle"           => 17,
    "Other"             => 18
  }

end
