class LineIndicatorsController < InheritedResources::Base
  layout "standard"
  respond_to :html, :xml, :json
  belongs_to :line

  def new
    @line_indicator = LineIndicator.new
    @line_indicator.line_id = params[:line_id]
    new!
  end
  
  protected

  def collection
    @line ||= Line.find(params[:line_id])
    @line_indicators ||= LineIndicator.find_all_by_line_id(params[:line_id])
    
  end

  def resource
    @line ||= Line.find(params[:line_id])
    @line_indicator ||= LineIndicator.find(params[:id])
  end

  def build_resource
    @line ||= Line.find(params[:line_id])
    @line_indicator ||= LineIndicator.new params[:line_indicator]
  end

end
