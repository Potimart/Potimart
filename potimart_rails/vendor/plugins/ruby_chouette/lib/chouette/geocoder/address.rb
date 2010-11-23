module Chouette::Geocoder
  class Address

    attr_reader :road, :street_number

    def initialize(road, street_number = nil)
      @road, @street_number = road, street_number
    end

    delegate :number_begin, :number_end, :number_range, :number_at_half_street, :city, :to => :road

    def name
      [street_number, road.name].compact.join(' ')
    end

    def to_lat_lng
      number = (street_number or number_at_half_street)
      if section = road.section_at(number)
        section.lat_lng_at(number)
      else
        road.sections.first.to_lat_lng
      end
    end
    
    def ==(other)
      other and other.road == road and other.street_number == street_number
    end

  end
end
