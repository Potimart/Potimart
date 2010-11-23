class JourneyPatternStopPoint < ChouetteActiveRecord
  belongs_to :route
  belongs_to :line
  belongs_to :journey_pattern
  belongs_to :stop_point
  belongs_to :stop_area
  belongs_to :commercial_stop_area, :class_name => "StopArea"
  
  named_scope :select_line, lambda { |line_id| { :conditions => { :line_id => line_id }}}
  named_scope :select_commercial_stop_area, lambda { |stop_area_id| { :conditions => { :commercial_stop_area_id => stop_area_id }}}
  named_scope :terminus, :conditions => { :terminus => true}
  named_scope :arrival, :conditions => [ "position > 1"]
  named_scope :outward_direction, :conditions => { :is_outward => true}
  named_scope :return_direction, :conditions => { :is_outward => false}
  named_scope :select_journey_pattern, lambda { |journey_pattern_id| {
      :conditions => { :journey_pattern_id => journey_pattern_id },
      :order => :position}}

  def self.lines_by_commercial_stop( commercial_ids=[])
    jpsp_array = if commercial_ids.empty?
        JourneyPatternStopPoint.all
      else
        self.select_commercial_stop_area( commercial_ids)
      end

    line_by_id = {}
    jpsp_array.map(&:line_id).uniq.each { |line_id| line_by_id[line_id] = Line.find(line_id)}

    lines_by_stop = {}
    jpsp_array.group_by(&:commercial_stop_area_id).each do |commercial_id, jpsps|
      jpsps.map(&:line_id).uniq.each do |line_id|
        (lines_by_stop[commercial_id] ||= []) << line_by_id[line_id]
      end
    end
    lines_by_stop
  end

  def self.day_types(day)
    2 ** (1 + day.wday) # it's the way Chouette define day_type
  end

  def self.search( date, line_id, stop_area_id)
    day_type = self.day_types( date)

    sql = <<-SQL
      SELECT
        vs.departuretime, v.journeypatternid as journey_pattern_id, v.id as vehicle_journey_id,
        vs.stoppointid as stop_point_id, jpsp.commercial_stop_area_id as terminus_id,
        jpsp.is_outward, sat.name as terminus_name
      FROM
        stoparea AS sa,
        stoppoint AS sp,
        timetable AS t,
        timetable_date AS td,
        timetablevehiclejourney AS tv,
        vehiclejourney AS v,
        route AS r,
        vehiclejourneyatstop AS vs,
        journey_pattern_stop_points jpsp,
        stoparea AS sat
      WHERE
        sa.parentid = #{stop_area_id}
        AND sp.stopareaid = sa.id
        AND td.timetableid = t.id
        AND #{SearchApi::SqlFragment.sanitize(['td.date = ?',date])}
        AND tv.timetableid = t.id
        AND tv.vehiclejourneyid = v.id
        AND v.routeid = r.id
        AND r.lineid = #{line_id}
        AND vs.stoppointid = sp.id
        AND vs.vehiclejourneyid = v.id
        AND jpsp.journey_pattern_id = v.journeypatternid
        AND jpsp.terminus = true
        AND jpsp.position > 1
        AND NOT jpsp.stop_point_id = sp.id
        AND sat.id=jpsp.commercial_stop_area_id

      UNION
      SELECT
        vs.departuretime, v.journeypatternid as journey_pattern_id, v.id as vehicle_journey_id,
        vs.stoppointid as stop_point_id, jpsp.commercial_stop_area_id as terminus_id,
        jpsp.is_outward, sat.name as terminus_name
      FROM
        stoparea AS sa,
        stoppoint AS sp,
        timetable AS t,
        timetable_period AS tp,
        timetablevehiclejourney AS tv,
        vehiclejourney AS v,
        route AS r,
        vehiclejourneyatstop AS vs,
        journey_pattern_stop_points jpsp,
        stoparea AS sat
      WHERE
        sa.parentid = #{stop_area_id}
        AND sp.stopareaid = sa.id
        AND #{SearchApi::SqlFragment.sanitize(['tp.periodstart <= ?',date])}
        AND #{SearchApi::SqlFragment.sanitize(['tp.periodend >= ?',date])}
        AND t.id = tp.timetableid
        AND #{SearchApi::SqlFragment.sanitize(['(t.intdaytypes & ?) = ?', day_type, day_type])}
        AND tv.timetableid = t.id
        AND tv.vehiclejourneyid = v.id
        AND v.routeid = r.id
        AND r.lineid = #{line_id}
        AND vs.stoppointid = sp.id
        AND vs.vehiclejourneyid = v.id
        AND jpsp.journey_pattern_id = v.journeypatternid
        AND jpsp.terminus = true
        AND jpsp.position > 1
        AND NOT jpsp.stop_point_id = sp.id
        AND sat.id=jpsp.commercial_stop_area_id
    SQL

    JourneyPatternStopPoint.connection.select_all(sql)
  end

  def self.load
    JourneyPatternStopPoint.transaction do
      JourneyPatternStopPoint.delete_all

      JourneyPattern.all.each do |jp|
        vehicle = VehicleJourney.find_by_journeypatternid(jp.id)
        next if vehicle.nil? # TODO : voir pourquoi il y a un pb sur MB

        route = Route.find vehicle.routeid
        stop_point_ids = route.stop_points.map(&:id)

        jpsp_array = []
        vehicle.vehicle_journey_at_stops.each do |vjsp|
          sp = StopPoint.find( vjsp.stoppointid)
          sa = sp.stop_area
          commercial_id = sa.get_commercial_stop_area.id rescue nil

          jpsp_array << JourneyPatternStopPoint.new( { :route_id => route.id,
            :is_outward => ( route.wayback=='A'),
            :line_id => route.lineid,
            :journey_pattern_id => vehicle.journeypatternid,
            :stop_point_id => sp.id,
            :stop_area_id => sa.id,
            :commercial_stop_area_id => commercial_id
          })
        end

        jpsp_array.sort! { |a,b|
          stop_point_ids.index(a.stop_point_id) <=> stop_point_ids.index(b.stop_point_id)
        }

        jpsp_array.each_with_index do |jpsp, index|
          jpsp.terminus = ( index==0 || index==(jpsp_array.size-1))
          jpsp.position = index+1
          jpsp.save!
        end
      end
    end
  end
end