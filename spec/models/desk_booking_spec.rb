# spec/models/desk_booking_spec.rb
require 'rails_helper'

RSpec.describe DeskBooking, type: :model do
  let(:user) { create(:user, time_zone: 'America/New_York') }
  let(:desk) { create(:desk) }

  describe '#active?' do
    subject(:desk_booking) { create(:desk_booking, user: user, desk: desk, start_datetime: start_datetime, end_datetime: end_datetime) }

    context 'when the booking is within the active period' do
      let(:start_datetime) { 1.hour.ago }
      let(:end_datetime) { 1.hour.from_now }

      it 'returns true' do
        Timecop.freeze(Time.current) do
          expect(desk_booking.active?).to be true
        end
      end
    end

    context 'when the current time is before the booking period' do
      let(:start_datetime) { 1.hour.from_now }
      let(:end_datetime) { 3.hours.from_now }

      it 'returns false' do
        Timecop.freeze(Time.current) do
          expect(desk_booking.active?).to be false
        end
      end
    end

    context 'when the current time is after the booking period' do
      let(:start_datetime) { 3.hours.ago }
      let(:end_datetime) { 1.hour.ago }

      it 'returns false' do
        Timecop.freeze(Time.current) do
          expect(desk_booking.active?).to be false
        end
      end
    end

    context 'when the time zone of the user affects the booking period' do
      let(:start_datetime) { 1.hour.ago }
      let(:end_datetime) { 1.hour.from_now }

      before do
        user.update(time_zone: 'America/Los_Angeles')
      end

      it 'returns true if the current time in the user timezone is between start and end times' do
        Timecop.freeze(Time.current) do
          expect(desk_booking.active?).to be true
        end
      end
    end
  end
end
