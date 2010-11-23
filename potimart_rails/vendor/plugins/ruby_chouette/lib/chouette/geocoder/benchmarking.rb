module Chouette::Geocoder
  module Benchmarking

    def benchmark(title, &block)
      seconds = Benchmark.realtime { yield }
      Chouette::Geocoder.logger.info "#{title} (#{('%.1f' % (seconds * 1000))}ms)"
    end

  end
end
