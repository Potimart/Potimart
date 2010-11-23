require 'csv'

class InseeCommune < ActiveRecord::Base
  set_primary_key :ogc_fid
  acts_as_geom :the_geom => :polygon

  def self.create_all(csv_file)
    InseeCommune.transaction do
      csv_file = File.read(csv_file) if File.exists?(csv_file)
      CSV::Reader.parse(csv_file) do |row|
        area = GeoRuby::SimpleFeatures::Geometry.from_hex_ewkb(row[1])
        if area.class.to_s != "GeoRuby::SimpleFeatures::Polygon"
          logger.error("The geometry is not a polygon for communes with id : #{row[0]}")
        else
          InseeCommune.create(:ogc_fid => row[0],
            :the_geom => area,
            :id  => row[2],
            :feattyp => row[3],
            :order00 => row[4],
            :order01 => row[5],
            :order02 => row[6],
            :order03 => row[7],
            :order04 => row[8],
            :order05 => row[9],
            :order06 => row[10],
            :order07 => row[11],
            :featarea => row[12],
            :featperim => row[13],
            :name => row[14],
            :namelc => row[15])
        end
      end
    end
    nil
  end

  def indicators()
    # find all stoparea's indicators in the commune
    indicators = Hash.new

    StopAreaGeo.intersects(self.the_geom).each do |stop_area_geo|
      stop_area_geo.stop_area_geo_indicator.each do |indicator|
        indicators.has_key?("#{indicator.name}") ? indicators["#{indicator.name}"] = indicator.value + indicators["#{indicator.name}"] : indicators["#{indicator.name}"] = indicator.value
      end
    end
    return indicators
  end

end
