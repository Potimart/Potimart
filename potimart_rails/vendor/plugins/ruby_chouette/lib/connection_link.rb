

class ConnectionLink < ChouetteActiveRecord
  set_table_name :connectionlink
  belongs_to :stop_area, :class_name => "StopArea", :foreign_key => "departureid"
  belongs_to :stop_area, :class_name => "StopArea", :foreign_key => "arrivalid"

  before_create :set_defaults

  def self.load_stop_area_proximity(radius)
    connection_by_id_couple = {}
    ConnectionLink.all.each do |c|
      connection_by_id_couple[ [c.departureid, c.arrivalid].sort.join("-")] = true
    end

    ConnectionLink.transaction do
      StopArea.without_parent.each do |s|
        unless (s.to_lat_lng.lat.nil? || s.to_lat_lng.lng.nil?)
          # don't create connection_link on same stop_area
          (StopArea.noparent_in_neighborhood(s.to_lat_lng, radius, 10)-[s]).each do |n|
            if connection_by_id_couple[ [s.id, n.id].sort.join("-")].nil?
              ConnectionLink.new(:departureid => s.id, :arrivalid => n.id,
                  :defaultduration => Time.at(n.access_time),
                  :objectid => "AGILIS:ConnectionLink:#{s.id}-#{n.id}").save
            end
          end
        end
      end
    end
  end

  private
    def set_defaults
      self.mobilityrestrictedsuitability = false unless @mobilityrestrictedsuitability
      self.stairsavailability = false unless @stairsavailability
      self.liftavailability = false unless @liftavailability
      self.creationtime = Time.now unless @creationtime
      self.objectversion = 1 unless @objectversion
      return true
    end
end
