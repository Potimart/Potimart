class AddTheGeomWgs84ForIgnRoutes < ActiveRecord::Migration

  def self.column_exists?(table, column)
    columns(table).any? { |c| puts c.name.inspect; c.name == column.to_s }
  end

  def self.up
    if column_exists?(:ign_routes, :the_geom) && !column_exists?(:ign_routes, :the_geom_wgs84)
      execute("select AddGeometryColumn('','ign_routes','the_geom_wgs84','4326','LINESTRING',4);")
      execute("update ign_routes set the_geom_wgs84 = transform(the_geom,4326);")
    else
      say("Don't modify test databases")
    end
  end
    
  def self.down
    if column_exists?(:ign_routes, :the_geom)
      execute("select DropGeometryColumn('','ign_routes','the_geom_wgs84');")
    end
  end
end
