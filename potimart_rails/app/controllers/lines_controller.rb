class LinesController < InheritedResources::Base
  layout "standard"
  respond_to :html, :xml, :json
  actions :index, :show

  #  def show
  #    @stop_area_geo = StopAreaGeo.find(params[:stop_area_geo_id])
  #    show!
  #  end

  #  protected
  #
  #  def collection
  #    @lines = StopAreaGeo.find(params[:stop_area_geo_id]).lines
  #  end
  #
  #  def ressource
  #    @line = Line.find(params[:id])
  #  end

end
