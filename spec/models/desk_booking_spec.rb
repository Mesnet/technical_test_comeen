# spec/models/desk_booking_spec.rb
require 'rails_helper'

RSpec.describe DeskBooking, type: :model do
  let(:user_ny) { create(:user, time_zone: 'America/New_York') }
  let(:user_la) { create(:user, time_zone: 'America/Los_Angeles') }
  let(:desk) { create(:desk) }

  before do
    # Freeze time to ensure consistent test results
    Timecop.freeze(Time.current)
  end

  after do
    # Unfreeze time after tests
    Timecop.return
  end

  describe '.starting_soon' do
    context 'when the booking is starting within the next 15 minutes' do
      let!(:desk_booking_ny) do
        create(
          :desk_booking,
          user: user_ny,
          desk: desk,
          start_datetime: 10.minutes.from_now.in_time_zone(user_ny.time_zone),
          end_datetime: 2.hours.from_now.in_time_zone(user_ny.time_zone),
          state: 'booked'
        )
      end

      it 'includes the booking' do
        expect(DeskBooking.starting_soon).to include(desk_booking_ny)
      end
    end

    context 'when the booking is starting beyond the next 15 minutes' do
      let!(:desk_booking_ny) do
        create(
          :desk_booking,
          user: user_ny,
          desk: desk,
          start_datetime: 20.minutes.from_now.in_time_zone(user_ny.time_zone),
          end_datetime: 3.hours.from_now.in_time_zone(user_ny.time_zone),
          state: 'booked'
        )
      end

      it 'does not include the booking' do
        expect(DeskBooking.starting_soon).not_to include(desk_booking_ny)
      end
    end

    context 'when the booking is in a different time zone' do
      let!(:desk_booking_la) do
        create(
          :desk_booking,
          user: user_la,
          desk: desk,
          start_datetime: 10.minutes.from_now.in_time_zone(user_la.time_zone),
          end_datetime: 2.hours.from_now.in_time_zone(user_la.time_zone),
          state: 'booked'
        )
      end

      it 'includes the booking in Los Angeles time zone' do
        expect(DeskBooking.starting_soon).to include(desk_booking_la)
      end
    end
  end

  describe '.ending_soon' do
    context 'when the booking is ending within the next 15 minutes' do
      let!(:desk_booking_ny) do
        create(
          :desk_booking,
          user: user_ny,
          desk: desk,
          start_datetime: 3.hours.ago.in_time_zone(user_ny.time_zone),
          end_datetime: 10.minutes.from_now.in_time_zone(user_ny.time_zone),
          state: 'checked_in'
        )
      end

      it 'includes the booking' do
        expect(DeskBooking.ending_soon).to include(desk_booking_ny)
      end
    end

    context 'when the booking is ending beyond the next 15 minutes' do
      let!(:desk_booking_ny) do
        create(
          :desk_booking,
          user: user_ny,
          desk: desk,
          start_datetime: 4.hours.ago.in_time_zone(user_ny.time_zone),
          end_datetime: 30.minutes.from_now.in_time_zone(user_ny.time_zone),
          state: 'checked_in'
        )
      end

      it 'does not include the booking' do
        expect(DeskBooking.ending_soon).not_to include(desk_booking_ny)
      end
    end

    context 'when the booking is in a different time zone' do
      let!(:desk_booking_la) do
        create(
          :desk_booking,
          user: user_la,
          desk: desk,
          start_datetime: 3.hours.ago.in_time_zone(user_la.time_zone),
          end_datetime: 10.minutes.from_now.in_time_zone(user_la.time_zone),
          state: 'checked_in'
        )
      end

      it 'includes the booking in Los Angeles time zone' do
        expect(DeskBooking.ending_soon).to include(desk_booking_la)
      end
    end
  end

  describe '#active?' do
    subject(:desk_booking) { create(:desk_booking, user: user, desk: desk, start_datetime: start_datetime, end_datetime: end_datetime) }

    context 'when the booking is within the active period for user in New York timezone' do
      let(:user) { user_ny }
      let(:start_datetime) { 1.hour.ago.in_time_zone(user.time_zone) }
      let(:end_datetime) { 1.hour.from_now.in_time_zone(user.time_zone) }

      it 'returns true' do
        Timecop.freeze(Time.current) do
          expect(desk_booking.active?).to be true
        end
      end
    end

    context 'when the current time is before the booking period for user in New York timezone' do
      let(:user) { user_ny }
      let(:start_datetime) { 1.hour.from_now.in_time_zone(user.time_zone) }
      let(:end_datetime) { 3.hours.from_now.in_time_zone(user.time_zone) }

      it 'returns false' do
        Timecop.freeze(Time.current) do
          expect(desk_booking.active?).to be false
        end
      end
    end

    context 'when the current time is after the booking period for user in New York timezone' do
      let(:user) { user_ny }
      let(:start_datetime) { 3.hours.ago.in_time_zone(user.time_zone) }
      let(:end_datetime) { 1.hour.ago.in_time_zone(user.time_zone) }

      it 'returns false' do
        Timecop.freeze(Time.current) do
          expect(desk_booking.active?).to be false
        end
      end
    end

    context 'when the booking is within the active period for user in Los Angeles timezone' do
      let(:user) { user_la }
      let(:start_datetime) { 1.hour.ago.in_time_zone(user.time_zone) }
      let(:end_datetime) { 1.hour.from_now.in_time_zone(user.time_zone) }

      it 'returns true' do
        Timecop.freeze(Time.current) do
          expect(desk_booking.active?).to be true
        end
      end
    end

    context 'when the current time is before the booking period for user in Los Angeles timezone' do
      let(:user) { user_la }
      let(:start_datetime) { 1.hour.from_now.in_time_zone(user.time_zone) }
      let(:end_datetime) { 3.hours.from_now.in_time_zone(user.time_zone) }

      it 'returns false' do
        Timecop.freeze(Time.current) do
          expect(desk_booking.active?).to be false
        end
      end
    end

    context 'when the current time is after the booking period for user in Los Angeles timezone' do
      let(:user) { user_la }
      let(:start_datetime) { 3.hours.ago.in_time_zone(user.time_zone) }
      let(:end_datetime) { 1.hour.ago.in_time_zone(user.time_zone) }

      it 'returns false' do
        Timecop.freeze(Time.current) do
          expect(desk_booking.active?).to be false
        end
      end
    end
  end
end
