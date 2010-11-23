Rails.configuration.after_initialize do
  # need to tell libraries to load
  require 'chouette_ext'
end

ActiveSupport::Dependencies.explicitly_unloadable_constants << 'Line'
Rails.configuration.to_prepare do
  # this debug message loads the Line class ...
  Rails.logger.debug "Customize Line/#{Line.id}"
  # Line is reloaded each time
  class Line
    has_many :line_indicators, :dependent => :destroy
    has_many :service_links
  end
end
