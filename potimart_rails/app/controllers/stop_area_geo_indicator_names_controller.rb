class StopAreaGeoIndicatorNamesController <  InheritedResources::Base
  respond_to :xml, :only => :index

  def collection
    @stop_area_geo_indicator_names = StopAreaGeoIndicator.names
  end
end
