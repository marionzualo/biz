RSpec.describe Biz::HoursNormalizer do
  describe '#normalize' do
    context 'when the hours are already normalized ' do
      let(:hours) { {mon: {'22:00' => '23:00'}} }
      subject { described_class.new(hours) }

      it 'normalizes the hours' do
        expect(subject.normalize).to eq(mon: {'22:00' => '23:00'})
      end
    end

    context 'when the end time is 00:00' do
      let(:hours) { {mon: {'22:00' => '00:00'}} }
      subject { described_class.new(hours) }

      it 'normalizes the hours' do
        expect(subject.normalize).to eq(mon: {'22:00' => '24:00'})
      end
    end

    context 'when the hours span multiple days' do
      let(:hours) { {mon: {'22:00' => '02:00'}} }
      subject { described_class.new(hours) }

      it 'normalizes the hours' do
        result = {
          mon: {'22:00' => '24:00'},
          tue: {'00:00' => '02:00'}
        }
        expect(subject.normalize).to eq(result)
      end
    end

    context 'when the hours span saturday and sunday' do
      let(:hours) { {sat: {'22:00' => '02:00'}} }
      subject { described_class.new(hours) }

      it 'normalizes the hours' do
        result = {
          sat: {'22:00' => '24:00'},
          sun: {'00:00' => '02:00'}
        }
        expect(subject.normalize).to eq(result)
      end
    end

    context 'when there are hours for multiple days of the week' do
      let(:hours) {
        {
          mon: {'22:00' => '02:00'},
          tue: {'08:00' => '10:00'},
          wed: {'11:00' => '14:00'}
        }
      }
      subject { described_class.new(hours) }

      it 'normalizes the hours' do
        normalized_hours = {
          mon: {'22:00' => '24:00'},
          tue: {'00:00' => '02:00', '08:00' => '10:00'},
          wed: {'11:00' => '14:00'}
        }
        expect(subject.normalize).to eq(normalized_hours)
      end
    end
  end
end
