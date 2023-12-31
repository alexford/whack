# frozen_string_literal: true

module Whack
  module RunnerHelpers
    include Whack::Utils

    def record_update_time(time)
      @last_update_times ||= []

      @last_update_times << time
      @last_update_times = @last_update_times.last(100)
    end

    # Average time it takes for the whole update loop, including UPS throttle wait
    def average_update_time
      # don't guess until we have enough data points
      return 0.0001 unless (@last_update_times || []).size > 50

      @last_update_times.sum(0.0) / @last_update_times.size
    end
  end
end
