class InseeCommunesController < InheritedResources::Base
  layout "standard"
  actions :index, :show
  respond_to :html, :xml, :json

end
