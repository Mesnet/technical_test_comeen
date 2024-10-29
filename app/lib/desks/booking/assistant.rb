# frozen_string_literal: true

module Desks
  module Booking
    class Assistant
      attr_reader :user, :starting, :ending

      def initialize(user, starting_datetime, ending_datetime)
        @user = user
        @starting = starting_datetime
        @ending = ending_datetime
      end

      def book!(desk: nil)
        with_available_desk(desk: desk) do |desk|
          DeskBooking.create!(user:, desk: desk, start_datetime: starting, end_datetime: ending)
        end
      rescue ActiveRecord::RecordInvalid => e
        raise Desks::Booking::Errors::DeskBookingError.new(e.record), "Could not save booking due to validation errors"
      end

      def book(desk: nil)
        book!(desk: desk)
      rescue Desks::Booking::Errors::DeskBookingError => e
        e.record
      end

      def with_available_desk(desk: nil)
        passed_desk_occupied = desk && booked_desks.exists?(id: desk.id)

        desk ||= select_random_available_desk
        if passed_desk_occupied
          raise Desks::Booking::Errors::NoDeskAvailableError.new(desk_booking_for_error(desk:)),
            "The selected desk is already booked"
        elsif desk.nil?
          raise Desks::Booking::Errors::NoDeskAvailableError.new(desk_booking_for_error(desk:)),
            "No desk available"
        end

        yield desk
      end

      private

      def select_random_available_desk
        available_desks = Desk.where.not(id: booked_desks)

        available_desks.sample
      end

      def booked_desks
        Desk.joins(:desk_bookings).merge(DeskBooking.overlapping(starting, ending))
      end

      def desk_booking_for_error(desk:)
        record = DeskBooking.new(user:, desk:, start_datetime: starting, end_datetime: ending)
        record.valid?
        if desk.nil?
          record.errors.add(:desk, "no desk available")
        else
          record.errors.add(:desk, "is not available")
        end

        record
      end
    end
  end
end
