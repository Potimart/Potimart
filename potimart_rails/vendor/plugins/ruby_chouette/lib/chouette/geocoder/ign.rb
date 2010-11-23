# -*- coding: utf-8 -*-
module Chouette::Geocoder
  module IGN
    
    def self.load_abbrevations
      file = "#{File.dirname(__FILE__)}/ign-abbrevations.yml"
      YAML.load(File.read(file)).inject({}) do |codes, pair|
        code, full_name = pair
        codes[code] = full_name.split
        codes
      end
    end

    @@ign_abbreviations = load_abbrevations

    def self.resolve_abbreviation(name)
      parts = name.split

      first_word = parts.shift
      parts.unshift @@ign_abbreviations.fetch(first_word, first_word)

      parts.join(' ')
    end

  end
end
