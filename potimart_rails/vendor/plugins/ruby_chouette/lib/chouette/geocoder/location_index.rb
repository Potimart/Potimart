# -*- coding: utf-8 -*-
module Chouette::Geocoder
  class LocationIndex

    attr_reader :exact_index, :phonetic_index

    def initialize
      @exact_index = WordIndex.new
      @phonetic_index = WordIndex.new
    end

    def push(location, attributes = {})
      location = Location.from(location)

      @exact_index.push location.words, location
      @phonetic_index.push location.phonetics, location
    end

    def find(word, options = {})
      word = StringContainer.to_token_or_word(word)
      index = index(options[:index])

      case options[:match]
      when :begin
        index.start_with word
      else
        index.get word
      end
    end

    def count(word, options = {})
      word = StringContainer.to_token_or_word(word)
      index = index(options[:index])

      case options[:match]
      when :begin
        index.count word
      else
        (index.get(word) or []).size
      end
    end

    def index(name)
      if name == :phonetic
        @phonetic_index
      else
        @exact_index
      end
    end

    def self.from_database
      @@database_location_index ||= LocationIndex.new.tap do |location_index|
        puts Benchmark.measure {
          Location.find_each(:include => "zone") do |location|
            location.zone_words # prefetch zone and its words
            location_index.push location
          end
        }
      end
    end

  end
end
