module Chouette::Geocoder
  class WordSetMatcher
    extend ActiveSupport::Memoizable

    attr_accessor :missing_input_penality, :unmatched_word_penality

    def initialize(reference_words, location, options = {})
      @missing_input_penality = 0.5
      @unmatched_word_penality = 0.1

      @reference_words = reference_words.to_tokens_or_words
      @location = Location.from(location)

      options.each { |k,v| send "#{k}=", v }
    end

    def initialize_copy(orig)
      super
      @reference_words = @reference_words.dup
    end

    def score
      match_words
    end
    memoize :score

    def match_words
      return 0 if @reference_words.empty?

      input_tokens = @reference_words
      words = @location.words.dup
      zone_words = @location.zone_words.dup

      score = 0

      until input_tokens.empty? or (words.empty? and zone_words.empty?)
        input_word = input_tokens.shift

        if @location.zone and input_word == @location.zone.zip_code
          score += 1
          next
        end

        matchings = match_word(input_word, words) + 
          match_word(input_word, zone_words).collect! { |m| [ m.first * 0.8, m.last ] }

        matching_score, matching_word = matchings.max_by{ |m| m.first }

        if matching_score and matching_score > 0
          words.delete(matching_word) or zone_words.delete(matching_word)
          score += matching_score
        else
          score -= missing_input_penality
        end
      end

      score -= words.size * unmatched_word_penality

      score
    end

    def match_word(input_word, words)
      if words.include?(input_word)
        [[1, input_word]]
      else
        returning([]) do |matchings|
          words.each do |w| 
            word_score = input_word.part_of(w)
            matchings << [ word_score, w ] if word_score > 0
          end

          words.each do |word|
            word.phonetics.each do |phonetic|
              if phonetic.size > 1
                input_word.phonetics.each do |input_phonetic|
                  phonetic_score = input_phonetic.part_of(phonetic)*0.4
                  matchings << [ phonetic_score, word ] if phonetic_score > 0
                end
              end
            end
          end
        end
      end
    end


  end
end
