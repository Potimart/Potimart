class InseeIrissController < InheritedResources::Base
  layout "standard"
  actions :index, :show
  respond_to :xml, :json

end
