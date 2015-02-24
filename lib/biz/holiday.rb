module Biz
  class Holiday

    include Concord.new(:date, :time_zone)

    def contains?(time)
      date == Time.new(time_zone).local(time).to_date
    end

    def to_time_segment
      TimeSegment.new(
        Time.new(time_zone).on_date(date, DayTime.midnight),
        Time.new(time_zone).on_date(date, DayTime.endnight)
      )
    end

  end
end
