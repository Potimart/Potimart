class InseeCommuneIndicatorsController < ApplicationController
  layout "standard"

  def index()
    @commune = InseeCommune.find(params[:insee_commune_id])
    @insee_commune_indicators = @commune.indicators
  end

end
