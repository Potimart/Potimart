module Chouette::Geocoder::IGN
  class Route < ChouetteActiveRecord
    set_table_name "ign_routes"
    set_primary_key :gid

    has_many :road_sections, :foreign_key => "ign_route_id"
    has_many :roads, :through => :road_sections

    def left_side
      @left_side ||= Side.new(self, :g) unless nom_rue_g.blank?
    end

    def right_side
      @right_side ||= Side.new(self, :d) unless nom_rue_d.blank?
    end

    def sides
      [left_side, right_side].compact
    end

    def self.find_each_side
      sides_attributes = [primary_key] + 
        Side.side_attributes_for(:g) + 
        Side.side_attributes_for(:d)

      Route.find_in_batches(:select => sides_attributes.join(',')) do |routes|
        routes.each do |route|
          route.sides.each do |side|
            yield side
          end
        end
      end
    end

    class Side

      attr_reader :route, :side_name

      def initialize(route, side_name)
        @route, @side_name = route, side_name
      end

      @@side_attributes = %w{nom_rue inseecom codevoie bornedeb bornefin}
      cattr_reader :side_attributes

      def self.side_attributes_for(side_name)
        side_attributes.collect do |attribute|
          "#{attribute}_#{side_name}"
        end
      end

      side_attributes.each do |attribute|
        define_method(attribute) do
          value = route.send "#{attribute}_#{side_name}"
          value == "NR" ? nil : value
        end
      end

      alias_method :name, :nom_rue
      alias_method :insee_code, :inseecom

      def number_range
        if self.bornedeb and self.bornefin and self.bornedeb <= self.bornefin
          Range.new self.bornedeb, self.bornefin
        end
      end

    end

  end
end
