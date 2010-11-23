require 'csv'

class InseeIris < ActiveRecord::Base
  set_primary_key :ogc_fid

  def self.find_at_point(geom)
    find :first, :conditions => [ "intersects(the_geom,geometryfromtext('POINT(? ?)',?))", geom.x, geom.y, geom.srid ]
  end

  def self.create_all(csv_file)
    InseeIris.transaction do
      csv_file = File.read(csv_file) if File.exists?(csv_file)
      CSV::Reader.parse(csv_file) do |row|
        the_geom = GeoRuby::SimpleFeatures::Geometry.from_hex_ewkb(row[1])

        if the_geom.class.to_s != "GeoRuby::SimpleFeatures::Polygon"
          logger.error("The geometry is not a polygon for iris with id : #{row[0]}")
        else
          InseeIris.create(:ogc_fid => row[0],
            :the_geom => the_geom,
            :code_iris => row[2],
            :nom_iris => row[3],
            :typ_iris => row[4],
            :code_insee => row[5],
            :nom_com => row[6],
            :psdc => row[7],
            :menages => row[8],
            :nblog => row[9],
            :code_depart => row[10],
            :code_reg => row[11])
        end

      end
    end
    nil
  end

end
