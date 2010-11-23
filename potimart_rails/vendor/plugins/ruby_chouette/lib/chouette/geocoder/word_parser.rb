# -*- coding: utf-8 -*-
module Chouette::Geocoder
  class WordParser
    extend ActiveSupport::Memoizable

    attr_reader :string

    def initialize(string, filters = WordParser.default_filters)
      @string, @filters = string, create_filters(filters)
    end

    def create_filters(filters)
      Array(filters).collect do |filter|
        if Class === filter 
          filter.new
        else
          filter
        end
      end
    end

    def preprend_filter(filter)
      @filters = create_filters(filter) + @filters
      self
    end

    def parts
      @parts ||= Token.tokenize(string).collect!(&:to_s)
    end

    def words
      apply_filters
      parts.collect(&:to_word)
    end
    memoize :words

    def apply_filters
      @filters.each do |filter|
        filter(filter)
      end
      self
    end

    def filter(filter = nil, &block)
      if block_given?
        raise "Use filter or block, not both" if filter
        filter = ProcFilter.new(block) 
      end

      @parts = parts.inject([]) do |filtered_parts, part|
        filtered_part = filter.filter part
        filtered_parts << filtered_part unless filtered_part.blank?
        filtered_parts.flatten
      end

      if filter.respond_to?(:flush)
        if flushed_part = filter.flush
          @parts << flushed_part
        end
      end

      self
    end

    def self.number?(part)
      part =~ /[0-9]+/ or
        RomanFilter.roman_number?(part) or
        TextNumberFilter.text_number?(part)
    end

    class ProcFilter

      def initialize(block)
        @block = block
      end

      def filter(part)
        @block.call part
      end

    end

    class OrdinalFilter

      def filter(part)
        [ "EME", "ER", "E" ].each do |suffix|
          if part.end_with?(suffix)
            tested_part = part[0..-(suffix.size+1)]

            unless RomanFilter.roman_number?(tested_part) 
              tested_part = tested_part[0..-2] if tested_part.last == "I"
            end

            return tested_part if WordParser.number?(tested_part)
          end
        end

        part
      end

    end

    class RomanFilter

      @@roman_table = 
        [ ["M"  , 1000],
          ["CM" , 900],
          ["D"  , 500],
          ["CD" , 400],
          ["C"  , 100],
          ["XC" ,  90],
          ["L"  ,  50],
          ["XL" ,  40],
          ["X"  ,  10],
          ["IX" ,   9],
          ["V"  ,   5],
          ["IV" ,   4],
          ["I"  ,   1] ]

      def filter(part)
        if RomanFilter.roman_number?(part)
          total = 0
          roman_string = part.dup
          @@roman_table.each do |roman, value|
            while roman_string.start_with?(roman)
              total += value
              roman_string.slice! roman
            end
          end
          total.to_s
        else
          part
        end
      end
      
      def self.roman_number?(part)
        part =~ /^[MDCLXVI]+$/
      end

    end

    class AbbreviationFilter

      @@abbreviations = {
        "ST" => "SAINT",
        "STE" => "SAINTE",
        "R" => "RUE",
        "BD" => "BOULEVARD",
        "AV" => "AVENUE",
        "FB" => "FAUBOURG",
        "MT" => "MONT",
        "PTE" => "PORTE",
        "GAL" => "GENERAL"
      }

      def filter(part)
        @@abbreviations[part] or part
      end
      
    end

    class StopWordFilter

      @@stop_words = 
        [ "au", "aux", "avec", "ce", "ces", "dans", "de", "des", "du", "elle", "en",
          "et", "eux", "il", "je", "la", "le", "leur", "lui", "ma", "mais", "me",
          "même", "mes", "moi", "mon", "ne", "nos", "notre", "nous", "on", "ou",
          "par", "pas", "pour", "qu", "que", "qui", "sa", "se", "ses", "son", "sur",
          "ta", "te", "tes", "toi", "ton", "tu", "une", "vos", "votre", "vous",
          "c", "d", "j", "l", "à", "a", "m", "n", "s", "t", "y", "et"
        ].collect!(&:upcase)

      def filter(part)
        stop_word?(part) ? nil : part
      end

      def stop_word?(part)
        @@stop_words.include?(part)
      end

    end

    class WordParser::TextNumberFilter

      @@numbers = {
        "UN" => 1,
        "PREMIER" => 1,
        "DEUX" => 2,
        "TROIS" => 3,
        "QUATRE" => 4,
        "CINQ" => 5,
        "CINQUIEME" => 5,
        "SIX" => 6,
        "SEPT" => 7,
        "HUIT" => 8,
        "NEUF" => 9,
        "NEUVIEME" => 9,
        "DIX" => 10,
        "ONZE" => 11,
        "DOUZE" => 12,
        "TREIZE" => 13,
        "QUATORZE" => 14,
        "QUINZE" => 15,
        "SEIZE" => 16,
        "VINGT" => 20,
        "TRENTE" => 30,
        "QUARANTE" => 40,
        "CINQUANTE" => 50,
        "SOIXANTE" => 60,
        "CENT" => 100,
        "MILLE" => 1000
      }

      def filter(part)
        if part_value = @@numbers[part.gsub(/S$/,'')]
          @values ||= []

          if multiplier?(part_value)
            if previous_value = @values.last
              if not multiplier?(previous_value)
                part_value = @values.pop * part_value
              end
            end
          end
          @values << part_value

          nil
        else
          if parsed_number = flush
            [parsed_number, part]
          else
            part
          end
        end
      end

      @@multipliers = [1000, 100, 20]
      def multiplier?(value)
        @@multipliers.include? value
      end

      def self.text_number?(part)
        @@numbers.key? part.gsub(/S$/,'')
      end
      
      def flush
        unless @values.blank?
          parsed_number = @values.sum.to_s
          @values = nil
          parsed_number
        end
      end

    end

    @@default_filters = [ StopWordFilter, AbbreviationFilter, OrdinalFilter, RomanFilter, TextNumberFilter ]
    cattr_reader :default_filters

  end
end
