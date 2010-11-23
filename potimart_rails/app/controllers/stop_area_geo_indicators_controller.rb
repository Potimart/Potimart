class StopAreaGeoIndicatorsController < InheritedResources::Base
  layout "standard"
  respond_to :html, :xml, :json
  nested_belongs_to :line, :route, :stop_area_geo

  def new
    @stop_area_geo_indicator = StopAreaGeoIndicator.new
    @stop_area_geo_indicator.stop_area_geo_id = params[:stop_area_geo_id]
    new!
  end

  protected
  
  def collection
    @line ||= Line.find(params[:line_id])
    @route ||= Route.find(params[:route_id])
    @stop_area_geo ||= StopAreaGeo.find(params[:stop_area_geo_id])
    @stop_area_geo_indicators ||= StopAreaGeoIndicator.find_all_by_stop_area_geo_id(params[:stop_area_geo_id])
  end

  def resource
    @line ||= Line.find(params[:line_id])
    @route ||= Route.find(params[:route_id])
    @stop_area_geo ||= StopAreaGeo.find(params[:stop_area_geo_id])
    @stop_area_geo_indicator ||= StopAreaGeoIndicator.find(params[:id])
  end

  def build_resource
    @line ||= Line.find(params[:line_id])
    @route ||= Route.find(params[:route_id])
    @stop_area_geo ||= StopAreaGeo.find(params[:stop_area_geo_id])
    @stop_area_geo_indicator ||= StopAreaGeoIndicator.new params[:stop_area_geo_indicator]
  end

end
