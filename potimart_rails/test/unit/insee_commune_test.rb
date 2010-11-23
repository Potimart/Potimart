require 'test_helper'

class InseeCommuneTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "get indicators from stop area geo" do
    insee_commune = InseeCommune.new(:name => "1", :namelc => "Ma commune", :the_geom => '11111111')
    stop_area_geo = StopAreaGeo.new

    assert true
  end

  test "find all stop area geo from geometry" do
    @bounds = Geokit::Bounds.normalize("48.2853,1.44727", "49.0854, 2.58577")
    @stop_area_geo = StopAreaGeo.new(:name => "Arrêt test", :the_geom => '0101000020E61000005BAB5B09395E01407B70BFE95B574840')
    assert StopAreaGeo.find(:all, :bounds => @bounds)
  end
end
