module Chouette::Geocoder
  class StringContainer
    extend ActiveSupport::Memoizable
    include Comparable

    attr_reader :string

    def initialize(string)
      @string = string.to_str
    end
    
    alias_method :to_s, :string
    alias_method :to_str, :string
    
    def hash
      string.hash
    end
    
    def ==(other)
      other && string == other.to_s
    end
    
    def eql?(other)
      other && string == other.to_s
    end

    def <=>(other)
      string <=> other.to_s
    end

    def match(target_string)
      target_string = target_string.to_s
      if target_string == self.string
        1
      elsif target_string.start_with?(self.string)
        self.string.length.to_f / target_string.length
      else
        0
      end
    end
    alias_method :part_of, :match

    def phonetics
      Phonetic.phonetics(string)
    end
    memoize :phonetics

    def size
      string.size
    end

    def self.serialize(string_containers)
      string_containers.join(' ')
    end

    def self.to_token_or_word(object)
      case object
      when Word, Token, Phonetic
        object
      else
        Chouette::Geocoder::Word.to_word(object)
      end
    end

    def self.to_tokens_or_words(array)
      if String === array
        Chouette::Geocoder::Word.to_words(array)
      else
        Array(array).collect { |e| StringContainer.to_token_or_word(e) }
      end
    end
    
  end
end
