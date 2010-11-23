module Chouette::Geocoder
  class WordIndex

    attr_reader :object_count

    def initialize
      @associations = Trie.new
      @object_count = 0
    end

    def trie
      @associations
    end

    def inspect
      "#<WordIndex:#{object_id} #{object_count} objects>"
    end

    def push(words, object)
      Array(words).each do |word|
        @associations[word.to_str] = object
      end
      @object_count += 1
    end

    def get(word)
      @associations[word.to_str] if word
    end

    def count(word)
      @associations.count(word)
    end

    def start_with(word)
      values = @associations.start_with(word)
      values.flatten!
      values
    end

  end
end
