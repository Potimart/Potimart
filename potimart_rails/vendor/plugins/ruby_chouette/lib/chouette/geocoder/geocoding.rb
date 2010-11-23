module Chouette::Geocoder
  class Geocoding
    extend ActiveSupport::Memoizable
    include Benchmarking

    @@default_location_index = nil
    cattr_accessor :default_location_index

    attr_accessor :timeout

    attr_reader :input_string
    attr_reader :location_index

    def initialize(input_string, options = {})
      options = { :location_index => (Geocoding.default_location_index or LocationIndex.new),
        :timeout => 0 }.update(options)

      @input_string = input_string

      @location_index = options[:location_index]
      @timeout = options[:timeout]

      @score_board = ScoreBoard.new
    end

    def locations_limit
      10
    end

    def input_tokens
      Token.tokenize(input_string)
    end
    memoize :input_tokens

    def last_token
      input_tokens.last
    end
    memoize :last_token

    def input_words
      input_string.to_words.tap do |words|
        words.shift if street_number
      end
    end
    memoize :input_words

    def input_phonetics
      Phonetic.phonetics(input_words).delete_if { |p| p.size <= 1 }
    end
    memoize :input_phonetics

    def street_number
      unless input_tokens.empty?
        value_of_first_token = input_tokens.first.to_s.to_i
        value_of_first_token unless value_of_first_token.zero?
      end
    end
    memoize :street_number

    def locations
      score_board.first(locations_limit).collect!(&:location)
    end
    memoize :locations

    def references
      Location.references(locations).collect! do |reference|
        Road === reference ? Address.new(reference, street_number) : reference
      end
    end

    def suggestions
      used_words = score_board.collect(&:location).collect!(&:words).flatten

      most_used_words = used_words.inject({}) do |words_count, word|
        words_count[word] = ((words_count[word] or 0) + 1)
        words_count
      end.sort_by(&:last).select { |word, score| score > 1 }.collect!(&:first).reverse

      (most_used_words - input_tokens).each do |word|
        Suggestion.new word
      end
    end
    memoize :suggestions

    def score_board
      load
      @score_board
    end

    def load
      return if @score_board_loaded
      @score_board_loaded = true

      benchmark("run all tasks") do
        Timeout.new(timeout).tap do |timeout|
          timeout.each(tasks) do |task|
            unless task.cost > 3000 or (task.cost > 500 and top_score > 1)
              task.run(timeout)
            end
          end
          
          Chouette::Geocoder.logger.debug "stop on timeout" if timeout.timeout?
        end
      end
    end

    class Timeout
      
      def initialize(time_length = nil)
        unless time_length.nil? or time_length.zero?
          @stop_at = time_length.from_now
        end
      end

      def timeout?
        Time.now >= @stop_at if @stop_at
      end

      def timeout!
        if timeout?
          Chouette::Geocoder.logger.debug "raise error"
          raise Error
        end
      end

      def each(elements)
        pending_elements = elements.dup
        until pending_elements.empty? or timeout?
          yield pending_elements.shift
        end
      end

      def to_s
        if @stop_at
          "timeout in #{(@stop_at - Time.now) * 1000} ms"
        else
          "no timeout"
        end
      end

      class Error < Interrupt 

      end

    end

    def tasks
      return [] if input_tokens.empty?

      tasks = returning([]) do |tasks|
        input_words.each do |word|
          tasks << Task.new(self, word)
        end
        input_words.each do |word|
          tasks << Task.new(self, word, :match => :begin)
        end
        # tasks << Task.new(self, last_token, :match => :begin)
        
        input_phonetics.each do |phonetic|
          tasks << Task.new(self, phonetic, :index => :phonetic)
        end
        input_phonetics.each do |phonetic|
          tasks << Task.new(self, phonetic, :match => :begin, :index => :phonetic)
        end
      end

      benchmark("sort all tasks") do
        tasks = tasks.sort_by(&:cost)
      end

      tasks
    end
    memoize :tasks

    class Task 
      extend ActiveSupport::Memoizable
      include Benchmarking

      attr_reader :geocoding, :input, :options
      
      def initialize(geocoding, input, options = {})
        @geocoding, @input, @options = 
          geocoding, input, options
      end

      delegate :location_index, :score, :to => :geocoding

      def locations
        location_index.find(input, options) or []
      end
      memoize :locations

      def cost
        location_index.count(input, options)
      end

      def run(timeout = Timeout.new)
        Chouette::Geocoder.logger.debug "scoring #{locations.size} locations for #{input} (#{options.inspect}) ..."
        benchmark("scored #{locations.size} locations for #{input} (#{options.inspect})") do
          timeout.each(locations) do |location|
            score location
          end
        end
      end

    end

    def top_ten_score
      top_ten = @score_board.first(10)
      unless top_ten.empty?
        top_ten.find_all { |s| s.score > 0 }.sum(&:score) / top_ten.size.to_f
      else
        0
      end
    end

    def top_score
      if top_scoring = @score_board.first
        top_scoring.score
      else
        0
      end
    end

    def score(location)
      unless @score_board.include?(location)
        @score_board.push new_scoring(location)
      end
    end

    def new_scoring(location)
      Scoring.new(location).tap do |scoring|
        scoring.score =
          WordSetMatcher.new(input_words, scoring.location).score
      end
    end

  end
end
