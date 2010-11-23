class ServiceLinksController < InheritedResources::Base
  layout "standard"
  respond_to :html, :xml, :geojson
  actions :index, :show
  belongs_to :line

end
