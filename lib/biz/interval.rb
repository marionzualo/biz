module Biz
  class Interval

    include Concord.new(:start_time, :end_time, :time_zone)

    def endpoints
      [start_time, end_time]
    end

    def contains?(time)
      (start_time...end_time).cover?(
        WeekTime.from_time(Time.new(time_zone).local(time))
      )
    end

    def to_time_segment(week)
      TimeSegment.new(
        *endpoints.map { |endpoint|
          Time.new(time_zone).during_week(week, endpoint)
        }
      )
    end

    def <=>(other)
      return nil unless other.respond_to?(:start_time, true)

      start_time <=> other.start_time
    end

  end
end
