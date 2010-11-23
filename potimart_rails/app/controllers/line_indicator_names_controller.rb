class LineIndicatorNamesController <  InheritedResources::Base
  respond_to :xml, :only => :index

  def collection
    @line_indicator_names = LineIndicator.names
  end
end
