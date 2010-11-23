class LinesByIndicatorController <  InheritedResources::Base
  layout "standard"
  respond_to :geojson, :only => :index

  def collection
    @service_links = ServiceLink.by_line_indicator_name(params[:name])
  end

end
