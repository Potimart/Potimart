# To change this template, choose Tools | Templates
# and open the template in the editor.

class RoutesController < InheritedResources::Base
  layout "standard"
  actions :index, :show, :stop_areas
  respond_to :html, :xml, :json

  def show
    #@stop_area_geo = StopAreaGeo.find(params[:stop_area_geo_id])
    @line = Line.find(params[:line_id])
    show!
  end
  
  protected

  def collection
    @routes = Line.find(params[:line_id]).routes
    @line = Line.find(params[:line_id])
  end

  def ressource
    @route = Route.find(params[:id])
  end


end
