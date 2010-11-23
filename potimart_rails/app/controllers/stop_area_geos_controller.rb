class StopAreaGeosController < InheritedResources::Base
  layout "standard"
  respond_to :html, :xml, :json
  actions :index, :show
  belongs_to :route

  def collection
    stopareas_id = []
    route = Route.find(params[:route_id])
    route.stop_areas.each do |stop_area|
      stopareas_id << stop_area.id
    end
    @stoparea_geos = StopAreaGeo.find_all_by_stoparea_id(stopareas_id)

    @route = Route.find(params[:route_id])
    @line = Line.find(params[:line_id])
  end
  
end
