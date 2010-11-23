module Chouette::Geocoder
  class Suggestion

    attr_accessor :words, :zone

    def initialize(words = [], zone = nil)
      @words, @zone = words, zone
    end

    def to_s
      @words.join(' ')
    end

  end
end
