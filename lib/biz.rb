require 'date'
require 'delegate'
require 'forwardable'
require 'set'

require 'abstract_type'
require 'clavius'
require 'equalizer'
require 'memoizable'
require 'tzinfo'

module Biz
  class << self

    extend Forwardable

    def configure(&config)
      Thread.current[:biz_schedule] = Schedule.new(&config)
    end

    delegate %i[
      intervals
      holidays
      time_zone
      periods
      date
      dates
      time
      within
      in_hours?
      business_hours?
      on_holiday?
    ] => :schedule

    private

    def schedule
      Thread.current[:biz_schedule] or fail 'Biz has not been configured.'
    end

  end
end

require 'date'
require 'biz/date'
require 'biz/time'

require 'biz/calculation'
require 'biz/hours_normalizer'
require 'biz/configuration'
require 'biz/dates'
require 'biz/day'
require 'biz/day_of_week'
require 'biz/day_time'
require 'biz/duration'
require 'biz/holiday'
require 'biz/interval'
require 'biz/periods'
require 'biz/schedule'
require 'biz/timeline'
require 'biz/time_segment'
require 'biz/week'
require 'biz/week_time'
require 'biz/version'
