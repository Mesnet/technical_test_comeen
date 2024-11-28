# spec/models/desk_booking_spec.rb
require 'rails_helper'

RSpec.describe DeskBooking, type: :model do
  let(:user) { User.create(email: "test@example.com") }
  let(:desk) { Desk.create(name: "Desk 1") }

  describe 'scopes' do
    describe '.starting_soon' do
      it 'returns bookings that are starting in 15 minutes or less' do
        # Create a booking that starts soon (less than 15 minutes from now)
        starting_soon_booking = DeskBooking.create(
          user: user,
          desk: desk,
          start_datetime: 10.minutes.from_now,
          end_datetime: 1.hour.from_now,
          state: 'booked'
        )

        # Create a booking that starts later
        future_booking = DeskBooking.create(
          user: user,
          desk: desk,
          start_datetime: 1.hour.from_now,
          end_datetime: 2.hours.from_now,
          state: 'booked'
        )

        expect(DeskBooking.starting_soon).to include(starting_soon_booking)
        expect(DeskBooking.starting_soon).not_to include(future_booking)
      end
    end

    describe '.ending_soon' do
      it 'returns bookings that are ending in 15 minutes or less' do
        # Create a booking that is ending soon (less than 15 minutes from now)
        ending_soon_booking = DeskBooking.create(
          user: user,
          desk: desk,
          start_datetime: 1.hour.ago,
          end_datetime: 10.minutes.from_now,
          state: 'booked'
        )

        # Create a booking that is ending later
        later_ending_booking = DeskBooking.create(
          user: user,
          desk: desk,
          start_datetime: 1.hour.ago,
          end_datetime: 1.hour.from_now,
          state: 'booked'
        )

        expect(DeskBooking.ending_soon).to include(ending_soon_booking)
        expect(DeskBooking.ending_soon).not_to include(later_ending_booking)
      end
    end
  end

  describe '#active?' do
    it 'returns true if current time is between start_datetime and end_datetime' do
      # Create an active booking (current time is between start and end)
      active_booking = DeskBooking.create(
        user: user,
        desk: desk,
        start_datetime: 1.hour.ago,
        end_datetime: 1.hour.from_now
      )

      expect(active_booking.active?).to be(true)
    end

    it 'returns false if current time is before start_datetime' do
      # Create a booking that starts in the future
      future_booking = DeskBooking.create(
        user: user,
        desk: desk,
        start_datetime: 1.hour.from_now,
        end_datetime: 2.hours.from_now
      )

      expect(future_booking.active?).to be(false)
    end

    it 'returns false if current time is after end_datetime' do
      # Create a booking that has already ended
      past_booking = DeskBooking.create(
        user: user,
        desk: desk,
        start_datetime: 2.hours.ago,
        end_datetime: 1.hour.ago
      )

      expect(past_booking.active?).to be(false)
    end
  end
end
