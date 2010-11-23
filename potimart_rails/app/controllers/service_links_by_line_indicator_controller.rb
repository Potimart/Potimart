class ServiceLinksByLineIndicatorController < ApplicationController
  layout "standard"

  def show
    @service_links = ServiceLink.by_line_indicator_name(params[:name])
    puts @service_links.count

    respond_to do |format|
      format.html # index.html.erb
      format.xml { render :xml => @service_links }
    end

  end

end
