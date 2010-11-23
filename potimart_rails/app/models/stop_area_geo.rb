class StopAreaGeo < ActiveRecord::Base
  belongs_to :stoparea
  has_many :stop_area_geo_indicator, :dependent => :destroy
  acts_as_geom :the_geom => :point

  def iris_intersection
    @iris ||= InseeIris.find_at_point(the_geom)
  end

  def self.create_all
    StopAreaGeo.transaction do
      StopArea.all.each do |stoparea|
        if stoparea.latitude and stoparea.longitude
          StopAreaGeo.create! :area_type => stoparea.areatype, :stoparea_id => stoparea.id, :name => stoparea.name, :the_geom => Point.from_x_y(stoparea.longitude, stoparea.latitude, 4326)
        end
      end
    end
    nil
  end

  def self.load_frequenting(csv_file)
    update_all :frequenting => 0
    logger.debug("Load frequenting for stoparea")
    csv_file = File.read(csv_file) if File.exists?(csv_file)
    CSV::Reader.parse(csv_file) do |row|
      commune_stoparea, stoparea_frequenting = row.values_at(5, 9)
      commune_stoparea_array = commune_stoparea.split(" : ")
      if !commune_stoparea_array.nil? && !commune_stoparea_array.empty?
        stoparea_name = commune_stoparea_array.second
        if stopareaGeo = StopAreaGeo.find(:all, :conditions => { :name => "#{stoparea_name}" }, :limit => 2)
          if(stopareaGeo.count == 1)
            stopareaGeo.first.update_attribute :frequenting, stoparea_frequenting
          else
            logger.error("Too much results for the stoparea name : #{stoparea_name}")
          end
        else
          logger.error("No way to find the stoparea name : #{stoparea_name}")
        end
      else
        logger.error("Unable to split the name commune stoparea : #{commune_stoparea}")
      end
    end
  end

  def lines
    lines = []
    JourneyPatternStopPoint.find_all_by_stop_area_id(self.stoparea_id).each do |journeypattern_stoppoint|
      lines << Line.find(:first, journeypattern_stoppoint.line_id)
    end
    return lines
  end

  def self.by_indicator_name(name)
    StopAreaGeo.find(:all, :include => [:stop_area_geo_indicator], :conditions => ["stop_area_geo_indicators.name = ?", name] )
  end
  
end
