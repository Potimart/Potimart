# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100929065208) do

# Could not dump table "geography_columns" because of following StandardError
#   Unknown type 'name' for column 'f_table_catalog' /home/luc/NetBeansProjects/potimart/vendor/plugins/postgis_adapter/lib/postgis_adapter/common_spatial_adapter.rb:52:in `table'/home/luc/NetBeansProjects/potimart/vendor/plugins/postgis_adapter/lib/postgis_adapter/common_spatial_adapter.rb:50:in `each'/home/luc/NetBeansProjects/potimart/vendor/plugins/postgis_adapter/lib/postgis_adapter/common_spatial_adapter.rb:50:in `table'/home/luc/.bundle/ruby/1.8/gems/activerecord-2.3.8/lib/active_record/schema_dumper.rb:72:in `tables'/home/luc/.bundle/ruby/1.8/gems/activerecord-2.3.8/lib/active_record/schema_dumper.rb:63:in `each'/home/luc/.bundle/ruby/1.8/gems/activerecord-2.3.8/lib/active_record/schema_dumper.rb:63:in `tables'/home/luc/.bundle/ruby/1.8/gems/activerecord-2.3.8/lib/active_record/schema_dumper.rb:25:in `dump'/home/luc/.bundle/ruby/1.8/gems/activerecord-2.3.8/lib/active_record/schema_dumper.rb:19:in `dump'/home/luc/.bundle/ruby/1.8/gems/rails-2.3.8/lib/tasks/databases.rake:256/home/luc/.bundle/ruby/1.8/gems/rails-2.3.8/lib/tasks/databases.rake:255:in `open'/home/luc/.bundle/ruby/1.8/gems/rails-2.3.8/lib/tasks/databases.rake:255/home/luc/.bundle/ruby/1.8/gems/rake-0.8.7/lib/rake.rb:636:in `call'/home/luc/.bundle/ruby/1.8/gems/rake-0.8.7/lib/rake.rb:636:in `execute'/home/luc/.bundle/ruby/1.8/gems/rake-0.8.7/lib/rake.rb:631:in `each'/home/luc/.bundle/ruby/1.8/gems/rake-0.8.7/lib/rake.rb:631:in `execute'/home/luc/.bundle/ruby/1.8/gems/rake-0.8.7/lib/rake.rb:597:in `invoke_with_call_chain'/usr/lib/ruby/1.8/monitor.rb:242:in `synchronize'/home/luc/.bundle/ruby/1.8/gems/rake-0.8.7/lib/rake.rb:590:in `invoke_with_call_chain'/home/luc/.bundle/ruby/1.8/gems/rake-0.8.7/lib/rake.rb:583:in `invoke'/home/luc/.bundle/ruby/1.8/gems/rails-2.3.8/lib/tasks/databases.rake:113/home/luc/.bundle/ruby/1.8/gems/rake-0.8.7/lib/rake.rb:636:in `call'/home/luc/.bundle/ruby/1.8/gems/rake-0.8.7/lib/rake.rb:636:in `execute'/home/luc/.bundle/ruby/1.8/gems/rake-0.8.7/lib/rake.rb:631:in `each'/home/luc/.bundle/ruby/1.8/gems/rake-0.8.7/lib/rake.rb:631:in `execute'/home/luc/.bundle/ruby/1.8/gems/rake-0.8.7/lib/rake.rb:597:in `invoke_with_call_chain'/usr/lib/ruby/1.8/monitor.rb:242:in `synchronize'/home/luc/.bundle/ruby/1.8/gems/rake-0.8.7/lib/rake.rb:590:in `invoke_with_call_chain'/home/luc/.bundle/ruby/1.8/gems/rake-0.8.7/lib/rake.rb:607:in `invoke_prerequisites'/home/luc/.bundle/ruby/1.8/gems/rake-0.8.7/lib/rake.rb:604:in `each'/home/luc/.bundle/ruby/1.8/gems/rake-0.8.7/lib/rake.rb:604:in `invoke_prerequisites'/home/luc/.bundle/ruby/1.8/gems/rake-0.8.7/lib/rake.rb:596:in `invoke_with_call_chain'/usr/lib/ruby/1.8/monitor.rb:242:in `synchronize'/home/luc/.bundle/ruby/1.8/gems/rake-0.8.7/lib/rake.rb:590:in `invoke_with_call_chain'/home/luc/.bundle/ruby/1.8/gems/rake-0.8.7/lib/rake.rb:583:in `invoke'/home/luc/.bundle/ruby/1.8/gems/rake-0.8.7/lib/rake.rb:2051:in `invoke_task'/home/luc/.bundle/ruby/1.8/gems/rake-0.8.7/lib/rake.rb:2029:in `top_level'/home/luc/.bundle/ruby/1.8/gems/rake-0.8.7/lib/rake.rb:2029:in `each'/home/luc/.bundle/ruby/1.8/gems/rake-0.8.7/lib/rake.rb:2029:in `top_level'/home/luc/.bundle/ruby/1.8/gems/rake-0.8.7/lib/rake.rb:2068:in `standard_exception_handling'/home/luc/.bundle/ruby/1.8/gems/rake-0.8.7/lib/rake.rb:2023:in `top_level'/home/luc/.bundle/ruby/1.8/gems/rake-0.8.7/lib/rake.rb:2001:in `run'/home/luc/.bundle/ruby/1.8/gems/rake-0.8.7/lib/rake.rb:2068:in `standard_exception_handling'/home/luc/.bundle/ruby/1.8/gems/rake-0.8.7/lib/rake.rb:1998:in `run'/home/luc/.bundle/ruby/1.8/gems/rake-0.8.7/bin/rake:31/home/luc/.bundle/ruby/1.8/bin/rake:19:in `load'/home/luc/.bundle/ruby/1.8/bin/rake:19

  create_table "insee_communes", :primary_key => "ogc_fid", :force => true do |t|
    t.column "id", :integer
    t.column "feattyp", :integer
    t.column "order00", :string
    t.column "order01", :string
    t.column "order02", :string
    t.column "order03", :string
    t.column "order04", :string
    t.column "order05", :string
    t.column "order06", :string
    t.column "order07", :string
    t.column "featarea", :integer
    t.column "featperim", :integer
    t.column "name", :string
    t.column "namelc", :string
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
    t.column "the_geom", :polygon, :srid => 4326
  end

  create_table "insee_iris", :primary_key => "ogc_fid", :force => true do |t|
    t.column "code_iris", :string
    t.column "nom_iris", :string
    t.column "typ_iris", :string
    t.column "code_insee", :string
    t.column "nom_com", :string
    t.column "psdc", :integer
    t.column "menages", :integer
    t.column "nblog", :integer
    t.column "code_depart", :string
    t.column "code_reg", :string
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
    t.column "the_geom", :polygon, :srid => 4326
  end

  create_table "journey_pattern_stop_points", :force => true do |t|
    t.column "journey_pattern_id", :integer
    t.column "route_id", :integer
    t.column "line_id", :integer
    t.column "stop_point_id", :integer
    t.column "stop_area_id", :integer
    t.column "commercial_stop_area_id", :integer
    t.column "position", :integer
    t.column "terminus", :boolean
    t.column "is_outward", :boolean
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  create_table "line_indicators", :force => true do |t|
    t.column "name", :string
    t.column "value", :integer
    t.column "line_id", :integer
    t.column "start_date", :date
    t.column "end_date", :date
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  add_index "line_indicators", ["name"], :name => "index_line_indicators_on_name"

  create_table "origin_destination_indicators", :force => true do |t|
    t.column "name", :string
    t.column "value", :integer
    t.column "stoparea_start_id", :integer
    t.column "stoparea_end_id", :integer
    t.column "start_date", :date
    t.column "end_date", :date
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  create_table "service_links", :force => true do |t|
    t.column "line_id", :integer
    t.column "route_id", :integer
    t.column "journeypattern_id", :integer
    t.column "stoparea_start_id", :integer
    t.column "stoparea_arrival_id", :integer
    t.column "departure_time", :datetime
    t.column "arrival_time", :datetime
    t.column "duration", :integer
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
    t.column "the_geom", :geometry, :srid => nil
    t.column "main_journey_pattern", :boolean
  end

  create_table "stop_area_geo_indicators", :force => true do |t|
    t.column "name", :string
    t.column "value", :integer
    t.column "stop_area_geo_id", :integer
    t.column "start_date", :date
    t.column "end_date", :date
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  add_index "stop_area_geo_indicators", ["name"], :name => "index_stop_area_geo_indicators_on_name"

  create_table "stop_area_geos", :force => true do |t|
    t.column "name", :string
    t.column "area_type", :string
    t.column "stoparea_id", :integer
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
    t.column "the_geom", :point, :srid => 4326
  end

end
