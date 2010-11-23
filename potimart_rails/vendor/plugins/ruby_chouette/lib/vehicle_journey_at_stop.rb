# id bigint NOT NULL,
# vehiclejourneyid bigint,
# stoppointid bigint,
# modifie boolean,
# arrivaltime time without time zone,
# departuretime time without time zone,
# waitingtime time without time zone,
# connectingserviceid character varying(255),
# boardingalightingpossibility character varying(255),


class VehicleJourneyAtStop < ChouetteActiveRecord
  set_table_name :vehiclejourneyatstop
  belongs_to :stop_point, :class_name => "StopPoint", :foreign_key => "stoppointid"
  belongs_to :vehicle_journey, :class_name => "VehicleJourney", :foreign_key => "vehiclejourneyid"
  
  def self.get_day_types(day)
    2 ** (1 + day.wday) # it's the way Chouette define day_type
  end

  def self.find_actives_by_route( date, route_id)
    day_type = self.get_day_types(date)
    sql = <<-SQL
      SELECT
        vs.id, vs.departuretime, vs.vehiclejourneyid, vs.isdeparture, vs.stoppointid
      FROM
        timetable AS t,
        timetable_date AS td,
        timetablevehiclejourney AS tv,
        vehiclejourney AS v,
        vehiclejourneyatstop AS vs
      WHERE
        td.timetableid = t.id
        AND #{SearchApi::SqlFragment.sanitize(['td.date = ?',date])}
        AND tv.timetableid = t.id
        AND tv.vehiclejourneyid = v.id
        AND v.routeid = #{route_id}
        AND vs.vehiclejourneyid = v.id
      UNION
      SELECT
        vs.id, vs.departuretime, vs.vehiclejourneyid, vs.isdeparture, vs.stoppointid
      FROM
        timetable AS t,
        timetable_period AS tp,
        timetablevehiclejourney AS tv,
        vehiclejourney AS v,
        vehiclejourneyatstop AS vs
      WHERE
        tp.timetableid = t.id
        AND #{SearchApi::SqlFragment.sanitize(['tp.periodstart <= ?',date])}
        AND #{SearchApi::SqlFragment.sanitize(['tp.periodend >= ?',date])}
        AND #{SearchApi::SqlFragment.sanitize(['(t.intdaytypes & ?) = ?', day_type, day_type])}
        AND tv.timetableid = t.id
        AND tv.vehiclejourneyid = v.id
        AND v.routeid = #{route_id}
        AND vs.vehiclejourneyid = v.id
    SQL
    vs_array = self.find_by_sql( sql)
    departure_by_v = {}
    vs_array.each { |vs| departure_by_v[vs.vehiclejourneyid] = vs.departuretime if vs.isdeparture}

    vs_array.sort { |a,b| departure_by_v[a.vehiclejourneyid] <=> departure_by_v[b.vehiclejourneyid]}
  end

end
