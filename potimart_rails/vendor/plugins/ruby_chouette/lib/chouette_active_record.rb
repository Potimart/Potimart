require 'erb'

class ChouetteActiveRecord < ActiveRecord::Base

  unless respond_to?(:find_in_batches)
    extend Chouette::Batches
  end

private
  def self.init_db_config
    paths = []
    paths << File.join(Rails.root, "config", "database_chouette.yml") if defined?(Rails)
    paths << File.join(RAILS_ROOT, "config", "database_chouette.yml") if defined?(RAILS_ROOT)
    paths << File.join(File.dirname(__FILE__), "..", "database_chouette.yml")

    path = paths.find { |p| File.exists?(p) }
    @@db_config = YAML.load(ERB.new(IO.read(path)).result)
  rescue =>  e
    puts "database_chouette.yml not found in #{paths.inspect} #{e.message} #{e.backtrace.join("\n")}"
    raise Exception.new( "chouette_database.yml not found in #{paths.inspect}")
  end
  
public 
  self.abstract_class = true
  
  self.init_db_config
  conn = @@db_config[Chouette.env] rescue nil

  if conn.nil?
    puts "No configuration for chouette database found RAILS_ENV=#{Chouette.env}"
  else
    establish_connection(conn)
  end

  def self.configurations
    @@db_config
  end
  
  def self.connected?
    ! self.connection.nil?
  rescue => e
    false
  end

end

