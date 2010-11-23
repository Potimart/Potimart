class Line < ChouetteActiveRecord
  set_table_name :line
  
#  has_many :events, :as => :associated
  belongs_to :company, :class_name => "Company", :foreign_key => "companyid"
  belongs_to :pt_network, :class_name => "PTNetwork", :foreign_key => "ptnetworkid"
  has_many :routes, :class_name => "Route", :foreign_key => "lineid", :dependent => :destroy
  has_one :line_property

  def clean_name
    name.unaccent.downcase.gsub(/(-|\s|\\|\/)/, '_')
  end
  
  def number_with_name
    "#{number rescue nil} #{name rescue nil}"
  end
  
  def stop_areas( wayback)
    routes.select { |sa| sa.wayback==wayback }.map( &:stop_areas).flatten.uniq
  end
  
  def unique_stop_areas
    physical_stop_area_ids = routes.map(&:stop_areas).flatten.uniq.map(&:parentid)
    StopArea.find physical_stop_area_ids
  end
  
  def json_stop_areas
    unique_stop_areas.map do |stop_area|
      {:x => stop_area.latitude, :y => stop_area.longitude, :name => stop_area.name}
    end.to_json
  end
  
end
