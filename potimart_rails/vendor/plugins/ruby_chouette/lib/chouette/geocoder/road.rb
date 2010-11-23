module Chouette::Geocoder
  class Road < ChouetteActiveRecord
    
    has_many :sections, :class_name => "Chouette::Geocoder::RoadSection"
    belongs_to :city

    validates_presence_of :name, :allows_blank => false
    validates_presence_of :city_id

    def save_as_a_new_record!
      @new_record = true
      save!
    end

    def number_range
      Range.new(self.number_begin, self.number_end)
    end

    def number_at_half_street
      ((self.number_end - self.number_begin) / 2.0).round + self.number_begin
    end

    def section_at(number)
      sections.find(:first, :conditions => ["number_begin <= ? and ? <= number_end", number, number])
    end

    @@ordered_sides = <<EOF
select city.id as city_id, side.name, side.ign_route_id, min(side.number_begin) as number_begin, max(side.number_end) as number_end from
(select gid as ign_route_id, inseecom_d as insee_code, nom_rue_d as name, least(bornedeb_d,bornefin_d) as number_begin, greatest(bornedeb_d,bornefin_d) as number_end from ign_routes where inseecom_d <> 'NR' and nom_rue_d is not null union 
select gid as ign_route_id, inseecom_g as insee_code, nom_rue_g as name, least(bornedeb_g,bornefin_g) as number_begin, greatest(bornedeb_g,bornefin_g) as number_end from ign_routes where inseecom_g <> 'NR' and nom_rue_g is not null) as side,
cities as city
where cast(side.insee_code as integer) = city.insee_code
group by city_id, side.name, side.ign_route_id
order by city_id, name;
EOF

    def self.create_all
      builder = Builder.new

      Road.connection.select_all(@@ordered_sides).each do |side_attributes|
        builder = builder.update(side_attributes)
        builder.push side_attributes
      end

      builder.save!
    end

    class Builder

      attr_accessor :raw_name, :city_id, :sections, :number_begin, :number_end

      def initialize(side_attributes = {})
        self.city_id, self.raw_name = 
          side_attributes["city_id"], side_attributes["name"]
        @sections = []
      end
      
      def update(side_attributes)
        if same_road(side_attributes)
          self 
        else
          save!
          Builder.new(side_attributes)
        end
      end

      def same_road(side_attributes)
        [self.city_id, self.raw_name] == 
          [side_attributes["city_id"], side_attributes["name"]]
      end

      def name
        IGN.resolve_abbreviation(raw_name)
      end

      def push(side_attributes)
        section = RoadSection.new(side_attributes.except("name", "city_id"))
        sections << section
        self.number_begin = [self.number_begin, section.number_begin].compact.min
        self.number_end = [self.number_end, section.number_end].compact.max
      end

      def empty?
        raw_name.nil? and city_id.nil?
      end

      def save!
        unless empty?
          road = Road.create! :name => self.name, :city_id => self.city_id, :number_begin => self.number_begin, :number_end => self.number_end 
          sections.each { |s| s.road = road ; s.save! }
        end
      end

    end

  end
end
