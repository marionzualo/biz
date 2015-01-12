RSpec.describe Biz do
  context "when configured" do
    before do
      described_class.configure do |config|
        config.work_hours = {sun: {'11:00' => '12:00'}}
        config.holidays   = [Date.new(2015, 12, 25)]
        config.time_zone  = 'Africa/Abidjan'
      end
    end

    describe ".intervals" do
      it "delegates to the top-level schedule" do
        expect(described_class.intervals).to eq(
          [
            Biz::Interval.new(
              Biz::WeekTime.start(week_minute(wday: 0, hour: 11)),
              Biz::WeekTime.end(week_minute(wday: 0, hour: 12)),
              TZInfo::Timezone.get('Africa/Abidjan')
            )
          ]
        )
      end
    end

    describe ".holidays" do
      it "delegates to the top-level schedule" do
        expect(described_class.holidays).to eq(
          [
            Biz::Holiday.new(
              Date.new(2015, 12, 25),
              TZInfo::Timezone.get('Africa/Abidjan')
            )
          ]
        )
      end
    end

    describe ".time_zone" do
      it "delegates to the top-level schedule" do
        expect(described_class.time_zone).to eq(
          TZInfo::Timezone.get('Africa/Abidjan')
        )
      end
    end

    describe ".periods" do
      it "delegates to the top-level schedule" do
        expect(described_class.periods.after(Time.utc(2006, 1, 1)).first).to eq(
          Biz::TimeSegment.new(Time.utc(2006, 1, 1, 11), Time.utc(2006, 1, 1, 12))
        )
      end
    end

    describe ".time" do
      it "delegates to the top-level schedule" do
        expect(described_class.time(2, :hours).after(Time.utc(2006, 1, 1))).to eq(
          Time.utc(2006, 1, 8, 12)
        )
      end
    end

    describe ".within" do
      it "delegates to the top-level schedule" do
        expect(
          described_class.within(
            Time.utc(2006, 1, 1, 11, 30),
            Time.utc(2006, 1, 8, 11, 30)
          )
        ).to eq Biz::Duration.hour(1)
      end
    end

    describe ".working?" do
      it "delegates to the top-level schedule" do
        expect(described_class.working?(Time.utc(2006, 1, 1, 11))).to eq true
      end
    end
  end

  context "when not configured" do
    before { Thread.current[:biz_schedule] = nil }

    it "blows up" do
      expect { described_class.intervals }.to raise_error
    end
  end
end