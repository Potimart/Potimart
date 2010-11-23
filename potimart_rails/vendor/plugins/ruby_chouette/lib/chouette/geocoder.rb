module Chouette
  module Geocoder

    mattr_accessor :logger

    def self.logger
      @@logger ||= Logger.new("log/geocoder.log")
    end

  end
end

class String
  def to_word
    Chouette::Geocoder::Word.to_word(self)
  end

  def to_words
    Chouette::Geocoder::Word.to_words(self)
  end

  def to_tokens_or_words
    Chouette::Geocoder::StringContainer.to_tokens_or_words(self)
  end
end

class Array
  def to_words
    Chouette::Geocoder::Word.to_words(self)
  end

  def to_tokens_or_words
    Chouette::Geocoder::StringContainer.to_tokens_or_words(self)
  end
end

require 'chouette/geocoder/trie'
require 'chouette/geocoder/benchmarking'
require 'chouette/geocoder/string_container'
require 'chouette/geocoder/token'
require 'chouette/geocoder/word'
require 'chouette/geocoder/word_parser'
require 'chouette/geocoder/phonetic'
require 'chouette/geocoder/word_index'
require 'chouette/geocoder/road'
require 'chouette/geocoder/road_section'
require 'chouette/geocoder/address'
require 'chouette/geocoder/location'
require 'chouette/geocoder/zone'
require 'chouette/geocoder/location_index'
require 'chouette/geocoder/ign'
require 'chouette/geocoder/ign/route'
require 'chouette/geocoder/scoring'
require 'chouette/geocoder/score_board'
require 'chouette/geocoder/word_set_matcher'
require 'chouette/geocoder/suggestion'
require 'chouette/geocoder/geocoding'
