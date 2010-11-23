module Chouette::Geocoder
  class ScoreBoard
    include Enumerable

    attr_reader :maximum_size

    def initialize(maximum_size = 30)
      @maximum_size = maximum_size
      @top_scorings = []
      @scorings_by_uid = {}
    end

    def each(&block)
      @top_scorings.each(&block)
    end

    def include?(location)
      @scorings_by_uid.has_key? location.uid
    end

    def push(scoring)
      unless include?(scoring)
        if index = index_for_score(scoring.score)
          @top_scorings.insert index, scoring
          @top_scorings.pop if size > maximum_size
        end

        @scorings_by_uid[scoring.uid] = scoring
      end
    end
    
    def index_for_score(score)
      return 0 if empty?

      index = last_index = @top_scorings.size

      while score > @top_scorings[index-1].score and index > 0
        index -= 1
      end

      index unless (index == last_index and full?)
    end

    def full?
      self.size == self.maximum_size
    end

    attr_reader :top_scorings
    protected :top_scorings

    delegate :empty?, :size, :to => :top_scorings

  end
end
