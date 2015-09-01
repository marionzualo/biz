module Biz
  class HoursNormalizer

    def initialize(hours)
      @hours = hours
    end

    def normalize
      hours.each_with_object({}) do |(wday, intervals), normalized_hours|
        intervals.each do |start_i, end_i|
          wday_interval, next_day_interval = normalize_interval(start_i, end_i)
          push_interval(wday, normalized_hours, wday_interval)
          if next_day_interval
            push_interval(next_day(wday), normalized_hours, next_day_interval)
          end
        end
      end
    end

    protected

    attr_reader :hours

    private

    def normalize_interval(start_time, end_time)
      if end_time == '00:00'
        [{start_time => '24:00'}]
      elsif start_time < end_time
        [{start_time => end_time}]
      else
        [
          {start_time => '24:00'},
          {'00:00' => end_time}
        ]
      end
    end

    def push_interval(day, hours, interval)
      if hours[day]
        hours[day].merge!(interval)
      else
        hours[day] = interval
      end
    end

    def next_day(wday)
      wday_index = ::Date::ABBR_DAYNAMES.find_index { |day_name|
        day_name == wday.to_s.capitalize
      }

      if wday_index == 6
        fday_index = 0
      else
        fday_index = wday_index + 1
      end

      ::Date::ABBR_DAYNAMES[fday_index].downcase.to_sym
    end

  end
end
