module Biz
  class Duration

    UNITS = Set.new(%i[second seconds minute minutes hour hours day days])

    include Concord.new(:seconds)
    include Comparable

    extend Forwardable

    class << self

      def with_unit(scalar, unit)
        unless UNITS.include?(unit)
          fail ArgumentError, 'The unit is not supported.'
        end

        public_send(unit, scalar)
      end

      def seconds(seconds)
        new(seconds)
      end

      alias_method :second, :seconds

      def minutes(minutes)
        new(minutes * Time::MINUTE)
      end

      alias_method :minute, :minutes

      def hours(hours)
        new(hours * Time::HOUR)
      end

      alias_method :hour, :hours

      def days(days)
        new(days * Time::DAY)
      end

      alias_method :day, :days

    end

    def initialize(seconds)
      super(Integer(seconds))
    end

    delegate %i[
      to_f
      to_i
      to_int
    ] => :seconds

    def in_seconds
      seconds
    end

    def in_minutes
      seconds / Time::MINUTE
    end

    def in_hours
      seconds / Time::HOUR
    end

    def in_days
      seconds / Time::DAY
    end

    def positive?
      seconds > 0
    end

    def abs
      self.class.new(seconds.abs)
    end

    def +(other)
      case other
      when self.class
        self.class.new(seconds + other.seconds)
      when Numeric
        self.class.new(seconds + other)
      else
        fail TypeError, "#{other.class} can't be coerced into #{self.class}"
      end
    end

    def -(other)
      case other
      when self.class
        self.class.new(seconds - other.seconds)
      when Numeric
        self.class.new(seconds - other)
      else
        fail TypeError, "#{other.class} can't be coerced into #{self.class}"
      end
    end

    def coerce(other)
      [self.class.new(other), self]
    end

    def <=>(other)
      return nil unless other.respond_to?(:to_i)

      seconds <=> other.to_i
    end

  end
end
