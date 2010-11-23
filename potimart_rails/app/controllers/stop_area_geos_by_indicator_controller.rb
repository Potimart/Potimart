class StopAreaGeosByIndicatorController <  InheritedResources::Base
  layout "standard"
  actions :show
  respond_to :xml, :geojson

  def show
    @stop_area_geos = StopAreaGeo.by_indicator_name(params[:name])
  end

end
