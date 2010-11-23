class ServiceLink < ActiveRecord::Base
  named_scope :visible_line, lambda{|line_id| {:conditions => ["line_id = ?", line_id]}}
  belongs_to :line

  def self.create_all(bounds = nil)
    @bounds = bounds
    if bounds.nil?
      @bounds = Geokit::Bounds.normalize("48.2853,1.44727", "49.0854, 2.58577")
    end

    # Find main journey pattern ( the journey pattern whth the max of vehicle journeys)
    main_journey_patterns = Hash.new
    Line.find(:all).each do |line|
      journey_patterns = Hash.new
      JourneyPatternStopPoint.find_by_sql("SELECT journey_pattern_id from journey_pattern_stop_points WHERE line_id = #{line.id} GROUP BY journey_pattern_id").each do |journey_pattern|
        journey_patterns[journey_pattern.journey_pattern_id] = JourneyPattern.find(journey_pattern.journey_pattern_id).vehicle_journeys.count
      end
      main_journey_patterns[journey_patterns.index(journey_patterns.values.max)] = journey_patterns.values.max
    end

    ServiceLink.transaction do
      @previous_journeypattern_stoppoint = JourneyPatternStopPoint.first;
      JourneyPatternStopPoint.find(:all, :offset => 1).each do |journeypattern_stoppoint|
        line_geometry = create_line_geometry(@previous_journeypattern_stoppoint.stop_area_id, journeypattern_stoppoint.stop_area_id)
        main_journey_pattern_value = main_journey_patterns.has_key?(journeypattern_stoppoint.journey_pattern_id)
        if(@previous_journeypattern_stoppoint.journey_pattern_id == journeypattern_stoppoint.journey_pattern_id && line_geometry != nil)
          #puts "Lien entre #{@previous_journeypattern_stoppoint.id} et #{journeypattern_stoppoint.id}"
          ServiceLink.create! :stoparea_start_id => @previous_journeypattern_stoppoint.stop_area_id,
            :stoparea_arrival_id => journeypattern_stoppoint.stop_area_id,
            :line_id => journeypattern_stoppoint.line_id,
            :route_id => journeypattern_stoppoint.route_id,
            :journeypattern_id => journeypattern_stoppoint.journey_pattern_id,
            :the_geom => line_geometry,
            :main_journey_pattern => main_journey_pattern_value
        end

        @previous_journeypattern_stoppoint = journeypattern_stoppoint
      end
    end
    nil
  end

  def self.create_line_geometry(first_stoparea_id, last_stoparea_id)
    first_stoparea_position = create_point_geometry(first_stoparea_id)
    last_stoparea_position = create_point_geometry(last_stoparea_id)

    if(accept?(first_stoparea_position) && accept?(last_stoparea_position))
      return LineString.from_points([first_stoparea_position, last_stoparea_position], 4326, false, false)
    else
      return nil
    end
  end

  def self.create_point_geometry(stoparea_id)
    stoparea = StopArea.find(:first, :conditions => {:id => stoparea_id})
    stoparea_position = Point.from_lon_lat(stoparea.longitude, stoparea.latitude, 4326)
    return stoparea_position
  end

  def self.accept?(position)
    if @bounds
      #puts "#{bounds} #{position.to_lat_lng}"
      #bounds.contains?(position.to_lat_lng)
      true
    else
      not (position.stoparea_latitude.zero? or position.stoparea_longitude.zero?)
    end
  end

  def self.by_line_indicator_name(name)
    ServiceLink.find(:all, :include => [:line => [:line_indicators]], :conditions => ["line_indicators.name = ?", name] )
  end

end
